using System;

namespace KeraLua
{
    /// Garbage Collector operations
    public enum LuaGC : int32
    {
        /// Stops the garbage collector.
        Stop = 0,
        /// Restarts the garbage collector.
        Restart = 1,
        /// Performs a full garbage-collection cycle.
        Collect = 2,
        /// Returns the current amount of memory (in Kbytes) in use by Lua.
        Count = 3,
        /// Returns the remainder of dividing the current amount of bytes of memory in use by Lua by 1024
        Countb = 4,
        /// Performs an incremental step of garbage collection.
        Step = 5,
        /// The options LUA_GCSETPAUSE and LUA_GCSETSTEPMUL of the function lua_gc are deprecated. You should use the new option LUA_GCINC to set them.
        //[Obsolete("Deprecatad since Lua 5.4, Use Incremental instead", false)]
        SetPause = 6,
        /// The options LUA_GCSETPAUSE and LUA_GCSETSTEPMUL of the function lua_gc are deprecated. You should use the new option LUA_GCINC to set them.
        //[Obsolete("Deprecatad since Lua 5.4, Use Incremental instead", false)]
        SetStepMultiplier = 7,
        /// returns a boolean that tells whether the collector is running
        IsRunning = 9,
        /// Changes the collector to generational mode with the given parameters (see §2.5.2). Returns the previous mode (LUA_GCGEN or LUA_GCINC).
        Generational = 10,
        /// Changes the collector to incremental mode with the given parameters (see §2.5.1). Returns the previous mode (LUA_GCGEN or LUA_GCINC).
        Incremental = 11,
    }

	extension LuaGC
	{
		[Inline]
		public static implicit operator int32(LuaGC status)
		{
			return status.Underlying;
		}
	}
}