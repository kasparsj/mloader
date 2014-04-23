/*
Copyright (c) 2012 Massive Interactive

Permission is hereby granted, free of charge, to any person obtaining a copy of 
this software and associated documentation files (the "Software"), to deal in 
the Software without restriction, including without limitation the rights to 
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
of the Software, and to permit persons to whom the Software is furnished to do 
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all 
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
SOFTWARE.
*/

import mtask.target.HaxeLib;
import mtask.target.Directory;

class Build extends mtask.core.BuildBase
{
	public function new()
	{
		super();
	}

	@target function haxelib(target:HaxeLib)
	{
		target.url = "http://github.com/massiveinteractive/mloader";
		target.description = "A cross platform Haxe library for loading resources with utilities for queueing and caching requests. Supports AVM2, JavaScript, Neko and C++.";
		target.versionDescription = "See https://github.com/massiveinteractive/mloader/blob/master/CHANGES.md";
		target.username = "massive";

		target.addTag("cross");
		target.addTag("utility");
		target.addTag("massive");

		target.addDependency("msignal");

		target.beforeCompile = function(path)
		{
			cp("src/*", path);
		}
	}

	@target function example(target:Directory)
	{
		target.beforeCompile = function(path)
		{
			mkdir(path);
			cp("example/*", path);
		}
	}

	@task function test()
	{
		cmd("haxelib", ["run", "munit", "test", "-coverage"]);
	}

	@task function teamcity()
	{
		invoke("test");
		cmd("haxelib", ["run", "munit", "report", "teamcity"]);

		invoke("build haxelib");
		invoke("build example");
	}
}
