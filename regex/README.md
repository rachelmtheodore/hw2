# Set 1: BIDS-style file name

I found many different ways to get the italicized portions saved into two regex groups; here's one:

```
(\w+)_|-(\d+(?=[_])_\w+$)
```
The italicized strings can be retrieved from groupName:1 and groupName:2.

```
[
  [
    {
      "content": "1000_",
      "isParticipating": true,
      "groupNum": 0,
      "groupName": null,
      "startPos": 4,
      "endPos": 9
    },
    {
      "content": "1000",
      "isParticipating": true,
      "groupNum": 1,
      "groupName": 1,
      "startPos": 4,
      "endPos": 8
    }
  ],
  [
    {
      "content": "nback_",
      "isParticipating": true,
      "groupNum": 0,
      "groupName": null,
      "startPos": 14,
      "endPos": 20
    },
    {
      "content": "nback",
      "isParticipating": true,
      "groupNum": 1,
      "groupName": 1,
      "startPos": 14,
      "endPos": 19
    }
  ],
  [
    {
      "content": "singleband_",
      "isParticipating": true,
      "groupNum": 0,
      "groupName": null,
      "startPos": 24,
      "endPos": 35
    },
    {
      "content": "singleband",
      "isParticipating": true,
      "groupNum": 1,
      "groupName": 1,
      "startPos": 24,
      "endPos": 34
    }
  ],
  [
    {
      "content": "-03_bold",
      "isParticipating": true,
      "groupNum": 0,
      "groupName": null,
      "startPos": 38,
      "endPos": 46
    },
    {
      "content": "",
      "isParticipating": false,
      "groupNum": 1,
      "groupName": 1,
      "startPos": -1,
      "endPos": -1
    },
    {
      "content": "03_bold",
      "isParticipating": true,
      "groupNum": 2,
      "groupName": 2,
      "startPos": 39,
      "endPos": 46
    }
  ],
  [
    {
      "content": "EXP23_",
      "isParticipating": true,
      "groupNum": 0,
      "groupName": null,
      "startPos": 51,
      "endPos": 57
    },
    {
      "content": "EXP23",
      "isParticipating": true,
      "groupNum": 1,
      "groupName": 1,
      "startPos": 51,
      "endPos": 56
    }
  ],
  [
    {
      "content": "rest_",
      "isParticipating": true,
      "groupNum": 0,
      "groupName": null,
      "startPos": 62,
      "endPos": 67
    },
    {
      "content": "rest",
      "isParticipating": true,
      "groupNum": 1,
      "groupName": 1,
      "startPos": 62,
      "endPos": 66
    }
  ],
  [
    {
      "content": "multiband_",
      "isParticipating": true,
      "groupNum": 0,
      "groupName": null,
      "startPos": 71,
      "endPos": 81
    },
    {
      "content": "multiband",
      "isParticipating": true,
      "groupNum": 1,
      "groupName": 1,
      "startPos": 71,
      "endPos": 80
    }
  ],
  [
    {
      "content": "-01_bold",
      "isParticipating": true,
      "groupNum": 0,
      "groupName": null,
      "startPos": 84,
      "endPos": 92
    },
    {
      "content": "",
      "isParticipating": false,
      "groupNum": 1,
      "groupName": 1,
      "startPos": -1,
      "endPos": -1
    },
    {
      "content": "01_bold",
      "isParticipating": true,
      "groupNum": 2,
      "groupName": 2,
      "startPos": 85,
      "endPos": 92
    }
  ]
]
```

I couldn't figure out how to get them saved as a single regex group, but this would put them in groups by BIDS values,

```
-(\w+)_\w+-(\w+)_\w+-(\w+)_\w+-(\w+$)
```
with each value in its own group:

```
[
  [
    {
      "content": "-1000_task-nback_acq-singleband_run-03_bold",
      "isParticipating": true,
      "groupNum": 0,
      "groupName": null,
      "startPos": 3,
      "endPos": 46
    },
    {
      "content": "1000",
      "isParticipating": true,
      "groupNum": 1,
      "groupName": 1,
      "startPos": 4,
      "endPos": 8
    },
    {
      "content": "nback",
      "isParticipating": true,
      "groupNum": 2,
      "groupName": 2,
      "startPos": 14,
      "endPos": 19
    },
    {
      "content": "singleband",
      "isParticipating": true,
      "groupNum": 3,
      "groupName": 3,
      "startPos": 24,
      "endPos": 34
    },
    {
      "content": "03_bold",
      "isParticipating": true,
      "groupNum": 4,
      "groupName": 4,
      "startPos": 39,
      "endPos": 46
    }
  ],
  [
    {
      "content": "-EXP23_task-rest_acq-multiband_run-01_bold",
      "isParticipating": true,
      "groupNum": 0,
      "groupName": null,
      "startPos": 50,
      "endPos": 92
    },
    {
      "content": "EXP23",
      "isParticipating": true,
      "groupNum": 1,
      "groupName": 1,
      "startPos": 51,
      "endPos": 56
    },
    {
      "content": "rest",
      "isParticipating": true,
      "groupNum": 2,
      "groupName": 2,
      "startPos": 62,
      "endPos": 66
    },
    {
      "content": "multiband",
      "isParticipating": true,
      "groupNum": 3,
      "groupName": 3,
      "startPos": 71,
      "endPos": 80
    },
    {
      "content": "01_bold",
      "isParticipating": true,
      "groupNum": 4,
      "groupName": 4,
      "startPos": 85,
      "endPos": 92
    }
  ]
]
```

I tried to use the "or" pipe to combine these two into one group; this,

```
-(\w+)_
```

which captures the 1000, nback, and singleband parts and this,

```
-(\d+(?=[_])_\w+$)
```

which captures the 03_bold parts, but putting them into a single group with the "or" pipe, like this,

```
-(\w+)_|-(\d+(?=[_])_\w+$)
```
didn't preserve the _bold, and I can't figure out why...


# Set 2: Ten digit US phone number

```
(\d{3}).+(\d{3}).(\d{4})
```

This regular expression captures area code (groupName: 1), exchange (groupName:2), and number (groupName:3).

```
[
  [
    {
      "content": "123-456-7891",
      "isParticipating": true,
      "groupNum": 0,
      "groupName": null,
      "startPos": 3,
      "endPos": 15
    },
    {
      "content": "123",
      "isParticipating": true,
      "groupNum": 1,
      "groupName": 1,
      "startPos": 3,
      "endPos": 6
    },
    {
      "content": "456",
      "isParticipating": true,
      "groupNum": 2,
      "groupName": 2,
      "startPos": 7,
      "endPos": 10
    },
    {
      "content": "7891",
      "isParticipating": true,
      "groupNum": 3,
      "groupName": 3,
      "startPos": 11,
      "endPos": 15
    }
  ],
  [
    {
      "content": "123) 555-5555",
      "isParticipating": true,
      "groupNum": 0,
      "groupName": null,
      "startPos": 17,
      "endPos": 30
    },
    {
      "content": "123",
      "isParticipating": true,
      "groupNum": 1,
      "groupName": 1,
      "startPos": 17,
      "endPos": 20
    },
    {
      "content": "555",
      "isParticipating": true,
      "groupNum": 2,
      "groupName": 2,
      "startPos": 22,
      "endPos": 25
    },
    {
      "content": "5555",
      "isParticipating": true,
      "groupNum": 3,
      "groupName": 3,
      "startPos": 26,
      "endPos": 30
    }
  ],
  [
    {
      "content": "860.865.9805",
      "isParticipating": true,
      "groupNum": 0,
      "groupName": null,
      "startPos": 31,
      "endPos": 43
    },
    {
      "content": "860",
      "isParticipating": true,
      "groupNum": 1,
      "groupName": 1,
      "startPos": 31,
      "endPos": 34
    },
    {
      "content": "865",
      "isParticipating": true,
      "groupNum": 2,
      "groupName": 2,
      "startPos": 35,
      "endPos": 38
    },
    {
      "content": "9805",
      "isParticipating": true,
      "groupNum": 3,
      "groupName": 3,
      "startPos": 39,
      "endPos": 43
    }
  ],
  [
    {
      "content": "800-865-9805",
      "isParticipating": true,
      "groupNum": 0,
      "groupName": null,
      "startPos": 46,
      "endPos": 58
    },
    {
      "content": "800",
      "isParticipating": true,
      "groupNum": 1,
      "groupName": 1,
      "startPos": 46,
      "endPos": 49
    },
    {
      "content": "865",
      "isParticipating": true,
      "groupNum": 2,
      "groupName": 2,
      "startPos": 50,
      "endPos": 53
    },
    {
      "content": "9805",
      "isParticipating": true,
      "groupNum": 3,
      "groupName": 3,
      "startPos": 54,
      "endPos": 58
    }
  ]
]
```