# Accessing container via Docker

This bit will attach my hw2-rmt directory to the bind directory on the rhancock/burc-lite container. The -v option specifies local volume:container volume; both need to be absolute paths. The instructions state to also include ```-v /tmp:/tmp``` in the connection, but I don't know where that goes. It doesn't work if I add a second -v option. Need to look into this further...

```
docker run -it --rm -v $HOME/Documents/GitHub/hw2-rmt:/bind rhancock/burc-lite /bin/bash
```
# Sidecars (of the non-libation variety)

I think a sidecar is a file that contains metadata from DICOM files. I generated these for the IBRAIN002 data. This is a folder in the raw directory; IBRAIN002 contains 8 child directories (named 1 - 7 plus beh). The dcm2bids_helper function seems pretty transparent.

```
dcm2bids_helper -d raw/IBRAIN002 -o bids/
```
The -d option species location of the data, and the -o options specifies where I want the sidecars to live. Because the filepaths are relative as shown above, I need to make sure to run this in the parent hw2-rmt directory (confirmed by first making an error in this, of course).

After executing this function, I've got a bunch of stuff in bids. There are seven .json files (I think these are the sidecars) and seven .nii.gz files (I think these are the zipped NIFTI files). NIFTI? NiFTI? NIfTI? The internet is not consistent on the capitalization scheme. I'm going with NIFTI. 

So I've now got seven sets of paired files (.json + .nii.gz). There were eight folders in the IBRAIN002 directory, so it seems that dcm2bids_helper knows not to do anything for a folder that doesn't contain DICOM files (i.e., the beh directory).

The .json files are awesome. They contain tons of information about the scanning protocol.

# Make a dictionary to guide the DICOM to BIDS conversion

This is done with a script (scripts/dcm2bids.json). We worked on modifying this for the IBRAIN002 data in class. This file maps information in the sidecars (the .json files) in bids to things we want preserved in the BIDS formatting transformation.

Important identifiers for BIDS formatting include data type and modality. In this dictionary, two type are identified (func, anat) as are three modalities (sbref, bold, T1w).

The "customLabels" part of the dictionary is really important, as this is where the user can specify key-value pairs for a specific study. For the current exercise, we're working with two one key-value pair, with two values for the key:

1. task-words
2. task-motor

Given that there is no "customLabels" defined for the anat data type, it seems that one doesn't need to include this parameter for everything.

In trying to track the dictionary entries with the files in the current bids directory, it seems that there is some issue because I don't have these files in the directory:

```
013_IBRAIN002_fMRI_motor_localizer_20171114132143.nii.gz
014_IBRAIN002_fMRI_motor_localizer_20171114132143.nii.gz
```
But I do have these files:

```
011_IBRAIN002_SpinEchoFieldMap_AP_20171114132143.nii.gz
012_IBRAIN002_SpinEchoFieldMap_ROPE_20171114132143.nii.gz
```
I'm guessing that the wrong files were downloaded from NiDB. I need to download the motor localizer ones (series 13 and 14, after checking things out in NiDB). This is a great place to point out the difference in preserving vs. re-setting folder names in the NiDB download options; I'm going to have to delete current directories 6 and 7 and replace them with the new ones I'm downloading (which I'm guessing will be automatically labeled directories 1 and 2).

While we wait for this to download, a few thoughts:

1. The dictionary should have entries for everything we want to convert. I have the impression that the BIDS script will automatically add run identifiers, so there only needs to be one dictionary entry for something that repeats in runs.
2. My handle of the data we're working with is that it has two runs of the task-words thing, each with two modalities (sbref, bold). And one run of the task-motor thing, also with two modalities. And finally, there is one anat type (with one modality, T1w).
3. Putting this all together, only having five dictionary entries for the seven NIFTI files makes sense.

Now that I've got the right files in data, confirmed by re-running the dcm2bids_helper function, continue to make sure that the dictionary is correct...

All looks good: protocol names match the custom labels, image comments are appropriate for modality label; func and anat types are identified correctly.


# Random interlude
Given the massive data files, and that this is all going to be committed to GitHub, it would be good to exclude the contents of the data folder from the git commit. Adding this to the .gitignore file should do the trick. AND THEN I LOOKED AT IT and Roeland had already taken care of this, brilliant!

# Create the conversion script

The scripts/convert.sh script will convert the dicom files into NIFTI files that are organized in BIDS format.

At the end of the day, this needs to be executable by running,

```
docker run [-v ...] rhancock/burc-lite <PATH>/convert.sh PARTICIPANT
```
where PARTICIPANT is the participant identifier.

First off, I made the script executable by running this in the scripts directory:

```
chmod 755 convert.sh
```
And then to test the path to executing this, I set the script to echo "Hello world!" and confirmed that it could be run using:

```
docker run -v $HOME/Documents/GitHub/hw2-rmt:/bind rhancock/burc-lite /bind/scripts/convert.sh
```
Of note, running this command when I was already in the container didn't work; I had to exit the container and then run the docker... command. Turns out if I'm already in the container, then I can run the script with just /bind/scripts/convert.sh, which seems incredibly obvious now.

Writing the script seemed way too easy:

```
Participant=$1

dcm2bids \
-d /bind/raw/$Participant \
-p $Participant \
-c /bind/scripts/dcm2bids.json \
-o /bind/bids
```
The only dummy mistake I made was (repeatedly) referring to the raw directory as the data directory, likely reflecting the fact that my standard analysis pipeline puts raw data in a directory called data.

HOLY MOLY - it worked! Pictures or it didn't happen:

![alt text](https://github.com/rachelmtheodore/hw2/blob/master/notes/BIDS.success.png "BIDS.success.png")

I did some spot checking to confirm that I didn't mess up the dictionary entries; my understanding is that, for example, these two .json files should be equivalent if I did the dictionary part right:

```
008_IBRAIN002_fMRI_words_run1_20171114132143.json
sub-IBRAIN002_task-words_run-01_bold.json
```
These additional files were created in the /bind directory:

```
info_env.txtinfo_fs.txtinfo_host.txtinfo_volumes.txt
```
A quick inspections suggests that they are reporting something about the container environment, but I should look into this further. Of note, they weren't generated when I ran the convert.sh script from the docker command directly, only when I ran it locally when I was already inside the container.

# Summary

This pipeline will take DICOM files and put them into the incredibly useful BIDS file structure. The key places where things could go wrong is in the dictionary entries. Those sidecar files are gold, but one needs to be extremely careful in setting the dictionary entries. It's good to know that if the dcm2bids_helper function is run before the conversion, you've got a way to double-check the entries (the sidecar files should be identical for converted/unconverted files). Other places ripe for error include setting the path for -d and -o in dcm2bids; if I always attach the container to the directory I want to work in, then the /bind/* path will work. 