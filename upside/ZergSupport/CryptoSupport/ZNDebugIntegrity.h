//
//  ZNDebugIntegrity.h
//  ZergSupport
//
//  Created by Victor Costan on 5/12/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//


// Protects the program against being debugged with gdb.
// This is not a complete protection, as mach service calls can still be used
// to get the same introspection that using gdb would grant.
//
// For best results, call this method right at the beginning of your main().
void ZNDebugIntegrity();
