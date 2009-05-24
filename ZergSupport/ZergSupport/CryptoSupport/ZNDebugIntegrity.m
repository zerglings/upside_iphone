//
//  ZNDebugIntegrity.h
//  ZergSupport
//
//  Created by Victor Costan on 5/12/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <dlfcn.h>
#import <sys/types.h>

#import <Foundation/Foundation.h>
#import <TargetConditionals.h>


// The iPhone SDK doesn't have <sys/ptrace.h>, but it does have ptrace, and it
// works just fine.
typedef int (*ptrace_ptr_t)(int _request, pid_t _pid, caddr_t _addr, int _data);
#if !defined(PT_DENY_ATTACH)
#define  PT_DENY_ATTACH  31
#endif  // !defined(PT_DENY_ATTACH)


void ZNDebugIntegrity() {
  // If all assertions are enabled, we're in a legitimate debug build.
#if TARGET_IPHONE_SIMULATOR || defined(DEBUG) || (!defined(NS_BLOCK_ASSERTIONS) && !defined(NDEBUG))
  return;
#endif

  // Lame obfuscation of the string "ptrace".
  char* ptrace_root = "socket";
  char ptrace_name[] = {0xfd, 0x05, 0x0f, 0xf6, 0xfe, 0xf1, 0x00};
  for (size_t i = 0; i < sizeof(ptrace_name); i++) {
    ptrace_name[i] += ptrace_root[i];
  }

  void* handle = dlopen(0, RTLD_GLOBAL | RTLD_NOW);
  ptrace_ptr_t ptrace_ptr = dlsym(handle, ptrace_name);
  ptrace_ptr(PT_DENY_ATTACH, 0, 0, 0);
  dlclose(handle);
}
