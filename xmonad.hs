import XMonad

main = xmonad defaultConfig {
	modMask = mod1Mask,
	terminal = "st -f 'Droid Sans Mono:size=10'",
	borderWidth = 0
}
