using System;

namespace KeraLua
{
    /// <summary>
    /// Enum for pseudo-index used by registry table
    /// </summary>
    public enum LuaRegistry : int32
    {
        /* LUAI_MAXSTACK		1000000 */
        /// <summary>
        /// pseudo-index used by registry table
        /// </summary>
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

    /// <summary>
    /// Registry index 
    /// </summary>
    public enum LuaRegistryIndex : int32
    {
        /// <summary>
        ///  At this index the registry has the main thread of the state.
        /// </summary>
        MainThread = 1,
        /// <summary>
        /// At this index the registry has the global environment. 
        /// </summary>
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