##### Package Control for sublime text 3:
<code>
import urllib.request,os,hashlib; h = '2915d1851351e5ee549c20394736b442' + '8bc59f460fa1548d1514676163dafc88'; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); by = urllib.request.urlopen( 'http://packagecontrol.io/' + pf.replace(' ', '%20')).read(); dh = hashlib.sha256(by).hexdigest(); print('Error validating download (got %s instead of %s), please try manual install' % (dh, h)) if dh != h else open(os.path.join( ipp, pf), 'wb' ).write(by)
</code>

##### List of useful package
* Git
* GitGutter
* Alignment
	<pre>
	Notice the hot key "Ctrl + Alt + A" conflicts with QQ, so we should change this hot key.
	Goto Preferences => Package Settings => Alignment => Key Bindding - User
	Then copy and paste the following configuration:
	**[
		{ "keys": ["ctrl+alt+f"], "command": "alignment" }
	]**
	</pre>
* ConvertToUTF8
* AllAutocomplete
	<pre>
	Find all matchs in all open files.
	</pre>
* Sublime CodeIntel
	<pre>
	Full-featured code intelligence and smart autocomplete engine 
	</pre>
* Bracket Highlighter
* Hex to HSL Color Convert
* SublimeAStyleFormatter
	<pre>
	https://github.com/timonwong/SublimeAStyleFormatter 
	It provides ability to format C/C++/C#/Java files.
	</pre>
* SublimeLinter
	<pre>
	Hieglight errors in your code.
	</pre>
