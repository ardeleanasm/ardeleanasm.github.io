---
layout: post
title: "First experience with WinApi"
description: ""
category: windows programming
tags: programming,c++
---


I discovered Linux Api, Linux System Programming some time ago and I found it amazing but I always thought "that's not enough!". And it's not! I have a lot of experience 
on Linux, I wrote device drivers, userspace applications using C and Linux API but I never tried to wrote some applications that use Windows API.
<!--more-->

This post will be the first about my experience with WinApi, system calls etc. I'm getting really tired to write apps on Windows in C++ CLR or C# and I 
want to try something more "low level". Note, all my small projects using WinApi will be integrated in Git under [projects/winapi](https://github.com/ardeleanasm/projects/tree/master/winapi/RegistryList).

Now, I should talk about the first small project, not done yet. RegistryList will be an application that will dump all Registry Entries<Key,Value> and will
allow user to set some filters, also maybe to clean/fix Registry Entries and extract and save data from entries. Maybe, in the last iteration, I'll add some 
UI to application and maybe I'll maintain it. But now, the application is just a bunch of C++ classes and can only dump Registry Entries<Key, Value> and print
them. It's not so nice...

Code.... hmmm, code can be found [HERE](https://github.com/ardeleanasm/projects/tree/master/winapi/RegistryList) but, let's talk a little.

I wrote a lot of C code and I don't really like return codes, if I can throw an exception. OK, on Linux, where I try to wrote all the applications in C code, 
I need to use return codes, but if I use WinApi and C++... Why not use exceptions?

So, in **KeyQueryExceptions.h** I defined some custom exceptions for the case where some parameters are not set or the some call to WinApi function return an error that
is not *ERROR_SUCCESS* ( I really found this name funny, ERROR_SUCCESS... It's a success or failure? :) ).


```c++
class CRegOpenKeyExException :public std::exception
{
private:
	std::string g_msg;
public:
	CRegOpenKeyExException(const std::string& msg) :g_msg(msg)
	{}

	CRegOpenKeyExException() :g_msg("RegOpenKeyEx call failed!"){}
	const char *ShowReason() const
	{
		return g_msg.c_str();
	}


};
```

In the code snippet is defined an exception that is thrown when RegOpenKeyExt function call return a value different from ERROR_SUCCESS.

```c++
#pragma once


class CKeyQuery
{
	CKeyQuery(CKeyQuery const &) = delete;
	CKeyQuery(CKeyQuery &&) = delete;
	CKeyQuery &operator=(CKeyQuery const &) = delete;
	CKeyQuery &operator=(CKeyQuery &&) = delete;
public:
	CKeyQuery();
	~CKeyQuery();
	void QueryKey(HKEY hKey, UINT32 * subKeys);
	void RegistryOpenKey(_Out_ PHKEY phkResult) throw (std::exception);
	void SethKey(HKEY hkey);
	void  SetSubKey(LPCTSTR lpSubKey);
	void  SetulOptions(DWORD ulOptions);
	void  SetSamdesired(REGSAM samDesired);
	void RegistryClose(_In_ HKEY hKey);
private:
	HKEY key;
	HKEY g_hkey;
	LPCTSTR g_lpSubKey;
	DWORD g_ulOptions;
	REGSAM g_samDesired;
	

};
```

The above code define a class CKeyQuery. The set methods are used to set the values that will be used as parameters to RegOpenKeyEx function. The constructor and
destructor of this class are used only for setting some default values, for now.

```c++
CKeyQuery::CKeyQuery()
{
	g_hkey = nullptr;
	g_lpSubKey = nullptr;
	g_ulOptions = 0;
	g_samDesired = 0;
}
CKeyQuery::~CKeyQuery()
{
	g_hkey = nullptr;
	g_lpSubKey = nullptr;
	g_ulOptions = 0;
	g_samDesired = 0;
}
```
The methods SethKey, SetSubKey,SetulOptions and SetSamdesired are simple one-line methods that will only set the values.

```c++
void CKeyQuery::RegistryOpenKey(_Out_ PHKEY phkResult) throw (std::exception)
{
	if (g_hkey == nullptr)
	{
		throw new CParametersNotSetException("hkey parameter was not set");
	}
	if (g_lpSubKey == nullptr){
		throw new CParametersNotSetException("lpSubKey was not set!");
	}
	if (RegOpenKeyEx(g_hkey, g_lpSubKey, g_ulOptions, g_samDesired, phkResult) != ERROR_SUCCESS)
	{
		throw new CRegOpenKeyExException();
	}
}
```
RegistryOpenKey is a wrapper on RegOpenKeyEx system call. Here, I only test if hkey and lpSubKey are not nullptr( are not default values) and call RegOpenKeyEx. 
Here is where I used the exceptions, cause I don't like returning error codes. :)

And now, surprise, I won't describe the most important method, `void CKeyQuery::QueryKey(HKEY hKey, UINT32 *subKeys)`. Why? Because the most part of it 
was took from [Microsoft](https://msdn.microsoft.com/en-us/library/windows/desktop/ms724256(v=vs.85).aspx). When the application will be more complex and this
function will not be "copy-paste" entirely I'll come with another article describing the modifications that I done.

Conclusions? 
Hmmm, I'm really impressed until now. I searched and found a book about [Windows System Programming](http://www.amazon.com/Windows-Programming-Addison-Wesley-Microsoft-Technology/dp/0321657748)
and I start to read it. I really like, even if the Hungarian notation conventions adopded by Microsoft maybe seems strange ( trust me, I saw notations even stranger).
I'm really curious what I'll can do, maybe I'll start also to read more about drivers ( even if I participated at a course about Windows Device Drivers, I 
never wrote one by myself, I just copy-pasted some code).


