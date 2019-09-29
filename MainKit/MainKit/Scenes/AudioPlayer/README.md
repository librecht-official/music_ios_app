### AudioPlayer UI

Manual layout is used here via 'Layout' framework, to easily animate player view expanded/collapsed states transitions. Since this states displays different layouts (but should be smoothely animated between each other), the layout hierarchy must be "flat". For this reason I desided to use manual layout instead of autolayout constraints.
