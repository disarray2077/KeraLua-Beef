namespace KeraLua
{
	/// Type for Beef callbacks In order to communicate properly with Lua, a C function must use the following protocol, which defines the way parameters and results are passed: a C function receives its arguments from Lua in its stack in direct order (the first argument is pushed first). So, when the function starts, lua_gettop(L) returns the number of arguments received by the function. The first argument (if any) is at index 1 and its last argument is at index lua_gettop(L). To return values to Lua, a C function just pushes them onto the stack, in direct order (the first result is pushed first), and returns the number of results. Any other value in the stack below the results will be properly discarded by Lua. Like a Lua function, a C function called by Lua can also return many results.
	public function int32 LuaFunction(lua_State luaState);

	/// Type for debugging hook functions callbacks.
	public function void LuaHookFunction(lua_State luaState, lua_Debug ar);

	/// Type for continuation functions
	public function int32 LuaKFunction(lua_State L, int32 status, lua_KContext ctx);

	/// The reader function used by lua_load. Every time it needs another piece of the chunk, lua_load calls the reader, passing along its data parameter. The reader must return a pointer to a block of memory with a new piece of the chunk and set size to the block size
	public function char8* LuaReader(lua_State L, void* ud, ref uint sz);

	public function int LuaWriter(lua_State L, void* p, uint size, void* ud);

	/// The type of the memory-allocation function used by Lua states. The allocator function must provide a functionality similar to realloc
	public function void* LuaAlloc(void* ud, void* ptr, uint osize, uint nsize);

	/// Type for warning functions
	public function void LuaWarnFunction(void* ud, char8* msg, int32 tocont);
}