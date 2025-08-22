using System;

namespace KeraLua
{
    /// Lua types
    public enum LuaType : int32
    {
        None = -1,
        /// LUA_TNIL
        Nil = 0,
        /// LUA_TBOOLEAN
        Boolean = 1,
        /// LUA_TLIGHTUSERDATA
        LightUserData = 2,
        /// LUA_TNUMBER
        Number = 3,
        /// LUA_TSTRING
        String = 4,
        /// LUA_TTABLE
        Table = 5,
        /// LUA_TFUNCTION
        Function = 6,
        /// LUA_TUSERDATA
        UserData = 7,
        /// LUA_TTHREAD
        Thread = 8,
    }

	extension LuaType
	{
		[Inline]
		public static implicit operator int32(LuaType status)
		{
			return status.Underlying;
		}
	}
}