A simple tool that generates a cs 1.6 styled command menu config for source engine games (tested only in tf2)

```
if you wanna make menu's fonts bigger you can drop custom folder into 'Team Fortress 2/tf/'
if you have any hud installed, it might override the file, so you have to mannualy patch sourcescheme.res or some UIs(console, server browser...) will use default colors

example with ToonHUD
open toonhud/resource/sourcescheme.res
find
```
```
Fonts
{
```
```
and append this after '{'
```
```
"DefaultFixed"
{
	"1"
	{
		"name"		 "Lucida Console" [$WINDOWS]
		"name"		 "Lucida Console" [$X360]
		"name"		 "Monaco" [$POSIX]
		"tall"		"21"
		"weight"	"100"
	}

}

"DefaultFixedDropShadow"
{
	"1"
	{
		"name"		 "Lucida Console" [$WINDOWS]
		"name"		 "Lucida Console" [$X360]
		"name"		 "Monaco" [$POSIX]
		"tall"		"21"
		"weight"	"100"
		"dropshadow" "1"
	}
}
```

https://nav.dl.sourceforge.net/project/luabinaries/5.4.2/Tools%20Executables/lua-5.4.2_Win32_bin.zip


![](https://i.imgur.com/ymN2UcB.png)
![](https://i.imgur.com/uPPNieN.png)
```
lua54.exe commandmenu_generator.lua example.txt
```

![](https://i.imgur.com/UhDYwLN.png)
![](https://i.imgur.com/MvAcvyW.png)
```
lua54.exe commandmenu_generator.lua example.txt -extended
```
