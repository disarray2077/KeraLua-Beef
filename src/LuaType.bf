using System;

namespace KeraLua
{
    /// <summary>
    /// Lua types
    /// </summary>
    public enum LuaType : int32
    {
        /// <summary>
        /// 
        /// </summary>
        None = -1,
        /// <summary>
        /// LUA_TNIL
        /// </summary>
        Nil = 0,
        /// <summary>
        /// LUA_TBOOLEAN
        /// </summary>
        Boolean = 1,
        /// <summary>
        /// LUA_TLIGHTUSERDATA
        /// </summary>
        LightUserData = 2,
        /// <summary>
        /// LUA_TNUMBER
        /// </summary>
        Number = 3,
        /// <summary>
        /// LUA_TSTRING
        /// </summary>
        String = 4,
        /// <summary>
        /// LUA_TTABLE
        /// </summary>
        Table = 5,
        /// <summary>
        /// LUA_TFUNCTION
        /// </summary>
        Function = 6,
        /// <summary>
        /// LUA_TUSERDATA
        /// </summary>
        UserData = 7,
        /// <summary>
        /// LUA_TTHREAD
        /// </summary>
        /// //
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