/****************************************************************************
 Copyright (c) 2012 cocos2d-x.org
 
 http://www.cocos2d-x.org
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/

#ifndef __MOBILEBASEMARCROS_H__
#define __MOBILEBASEMARCROS_H__

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <stdarg.h>
#include <string>
#include <functional>
#include <thread>
#include <mutex>
#include <chrono>
#include <list>
#include <vector>
#include <map>

#if defined _WINDOWS_ || defined WIN32

#include <winsock2.h>
#include <windows.h>
#include <assert.h>
#include <ws2tcpip.h>
#include <winbase.h>
#include <process.h>

#include <shlwapi.h>
#pragma comment(lib, "shlwapi.lib")
#pragma comment(lib, "ws2_32.lib")

#else
#include <cassert>
#include <cerrno>
#include <stddef.h>
#include <netdb.h>
#include <signal.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/time.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/select.h>
#include <sys/socket.h>
//#include <sys/epoll.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <netinet/tcp.h>
#include <semaphore.h>
#include <string.h>
#include <strings.h>

#define INVALID_SOCKET			-1

typedef unsigned char BYTE;
typedef unsigned int DWORD;
typedef unsigned short WORD;
typedef int LONG;
typedef long long  LONGLONG;
typedef char WCHAR;
typedef unsigned int COLORREF;
typedef double DATE;
typedef void* LPVOID;
typedef const void* LPCVOID;
typedef void VOID;
typedef unsigned int UINT;

#define TRUE	1
#define FALSE	0

#define S_OK	0
#define S_FALSE	1

#endif	//OS_LINUX

#endif /* __MOBILEBASEMARCROS_H__ */

