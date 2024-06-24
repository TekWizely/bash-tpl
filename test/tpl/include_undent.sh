printf "%b\n" Hello\,\ world
	printf "%b\n" $'\tHello, world'
# L1
	printf "%b\n" Hello\,\ world
	# L2
		printf "%b\n" Hello\,\ world
	# /L2
	printf "%b\n" Hello\,\ world
# /L1
# L1
	printf "%b\n" $'\tHello, world'
	# L2
		printf "%b\n" $'\tHello, world'
	# /L2
	printf "%b\n" $'\tHello, world'
printf "%b\n" Hello\,\ world
# /L1
printf "%b\n" Hello\,\ world
	printf "%b\n" $'\tHello, world'
	# L2
		printf "%b\n" $'\tHello, world'
	# /L2
printf "%b\n" Hello\,\ world
