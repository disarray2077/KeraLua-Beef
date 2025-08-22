using System;
using System.Text;

namespace KeraLua
{
    /// Structure for lua debug information
    [CRepr]
    public struct LuaDebug
    {
        /// Debug event code
        public LuaHookEvent Event;
        /// a reasonable name for the given function. Because functions in Lua are first-class values, they do not have a fixed name: some functions can be the value of multiple global variables, while others can be stored only in a table field
        [Inline] public StringView Name => .(name);
        char8* name;
        /// explains the name field. The value of namewhat can be "global", "local", "method", "field", "upvalue", or "" (the empty string)
        [Inline] public StringView NameWhat => .(nameWhat);
        char8* nameWhat;
        /// the string "Lua" if the function is a Lua function, "C" if it is a C function, "main" if it is the main part of a chunk
        [Inline] public StringView What => .(what);
        char8* what;
        /// the name of the chunk that created the function. If source starts with a '@', it means that the function was defined in a file where the file name follows the '@'.
        [Inline] public StringView Source => .(source, SourceLength);
        char8* source;

        /// The length of the string source
        [Inline] public int32 SourceLength => (int32)sourceLen;
        int sourceLen;

        /// the current line where the given function is executing. When no line information is available, currentline is set to -1
        public int32 CurrentLine;
        public int32 LineDefined;
        /// the line number where the definition of the function ends.
        public int32 LastLineDefined;
        /// number of upvalues
        public uint8 NumberUpValues;
        /// number of parameters
        public uint8 NumberParameters;
        /// true if the function is a vararg function (always true for C functions).
        public bool IsVarArg;        /* (u) */
        /// true if this function invocation was called by a tail call. In this case, the caller of this level is not in the stack.
        public bool IsTailCall; /* (t) */

        /// The index on the stack of the first value being "transferred", that is, parameters in a call or return values in a return. (The other values are in consecutive indices.) Using this index, you can access and modify these values through lua_getlocal and lua_setlocal. This field is only meaningful during a call hook, denoting the first parameter, or a return hook, denoting the first value being returned. (For call hooks, this value is always 1.)
        public uint16 IndexFirstValue;   /* (r) index of first value transferred */

        /// The number of values being transferred (see previous item). (For calls of Lua functions, this value is always equal to nparams.)
        public uint16 NumberTransferredValues;   /* (r) number of transferred values */
        
        char8[60] shortSource;

        /// a "printable" version of source, to be used in error messages
        public StringView ShortSource
        {
            [Inline] get
            {
#unwarn
				return .(&shortSource[0]);
            }
        }

        void* i_ci;
    }
}