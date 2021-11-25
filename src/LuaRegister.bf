using System;

namespace KeraLua
{
    /// <summary>
    /// LuaRegister store the name and the function to register a native function
    /// </summary>
    [CRepr]
    public struct LuaRegister
    {
        /// <summary>
        /// Function name
        /// </summary>
        public char8* name;
        /// <summary>
        /// Function delegate
        /// </summary>
        public LuaFunction func;
    }
}