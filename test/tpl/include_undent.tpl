.INCLUDE hello_world.tpl
% # L1
	.INCLUDE hello_world.tpl
	% # L2
		.INCLUDE hello_world.tpl
	% # /L2
	.INCLUDE hello_world.tpl
.INCLUDE hello_world.tpl
% # /L1
	.INCLUDE hello_world.tpl
	% # L2
		.INCLUDE hello_world.tpl
	% # /L2
.INCLUDE hello_world.tpl
