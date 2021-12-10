printf "%s\n" Hello\,\ world
	printf "%s\n" $'\tHello, world'
# L1
	printf "%s\n" Hello\,\ world
	# L2
		printf "%s\n" Hello\,\ world
	# /L2
	printf "%s\n" Hello\,\ world
printf "%s\n" Hello\,\ world
# /L1
printf "%s\n" Hello\,\ world
	printf "%s\n" $'\tHello, world'
	# L2
		printf "%s\n" $'\tHello, world'
	# /L2
printf "%s\n" Hello\,\ world
