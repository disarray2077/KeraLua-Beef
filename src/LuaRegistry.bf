using System;

namespace KeraLua
{
    /// Enum for pseudo-index used by registry table
    public enum LuaRegistry : int32
    {
        /* LUAI_MAXSTACK		1000000 */
        /// pseudo-index used by registry table
        Index = -1000000 - 1000
    }

	extension LuaRegistry
	{
		[Inline]
		public static implicit operator int32(LuaRegistry status)
		{
			return status.Underlying;
		}
	}

    /// Registry index
    public enum LuaRegistryIndex : int32
    {
        /// At this index the registry has the main thread of the state.
        MainThread = 1,
        /// At this index the registry has the global environment.
        Globals = 2,
    }

	extension LuaRegistryIndex
	{
		[Inline]
		public static implicit operator int32(LuaRegistryIndex status)
		{
			return status.Underlying;
		}
	}
}