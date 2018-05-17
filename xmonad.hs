import XMonad
import qualified XMonad.StackSet as W
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
import XMonad.Util.EZConfig
import XMonad.Hooks.ManageDocks
import Data.Ratio
import Graphics.X11.ExtraTypes.XF86

main = xmonad $ defaultConfig {
	modMask = mod1Mask,
	terminal = "st -f 'Droid Sans Mono:size=10'",
	borderWidth = 0,
	startupHook = do
		spawn "xcompmgr"
		spawn "dunst"
		spawn "volnoti",
	manageHook = composeOne [isDialog -?> doF W.shiftMaster, Just <$> doF W.swapDown],
	layoutHook = avoidStruts $
		(Mirror $ Tall 1 (3/100) (2/3))
		||| Tall 1 (3/100) (2/3)
		||| Full
} `additionalKeysP` [
	("M-S-p", spawn "passmenu --type")
	] `additionalKeys` [
	((0, xF86XK_AudioRaiseVolume), spawn "volnoti-show $(amixer set Master,0 5%+ | grep -o '[[:digit:]]*%' | head -n 1)"),
	((0, xF86XK_AudioLowerVolume), spawn "volnoti-show $(amixer set Master,0 5%- | grep -o '[[:digit:]]*%' | head -n 1)"),
	((0, xF86XK_AudioMute), spawn "amixer set Master,0 toggle | grep '\\[on\\]' && volnoti-show $(amixer get Master,0 | grep -o '[[:digit:]]*%' | head -n 1) || volnoti-show -m"),
	((0, xF86XK_AudioMicMute), spawn "amixer set Capture,0 toggle | grep '\\[on\\]' && notify-send --urgency low 'Mic unmuted' || notify-send --urgency low 'Mic muted'"),
	((0, xF86XK_MonBrightnessUp), spawn "light -A 5"),
	((0, xF86XK_MonBrightnessDown), spawn "light -U 5")
	]
