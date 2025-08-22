using System;

namespace KeraLua
{
    /// LuaRegister store the name and the function to register a native function
    [CRepr]
    public struct LuaRegister
    {
        /// Function name
        public char8* name;
        /// Function delegate
        public LuaFunction func;
    }
}