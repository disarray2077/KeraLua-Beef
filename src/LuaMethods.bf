using System;
using System.Security;

namespace KeraLua
{
	public typealias lua_State = int;
	public typealias lua_KContext = int;
	public typealias lua_Integer = int64;
	public typealias lua_Number = double;
	public typealias lua_Debug = int;

    public static class LuaMethods
    {
#if KERALUA_STATIC
		private const String LuaLibraryName = String.Empty;
#elif BF_PLATFORM_IOS
        private const String LuaLibraryName = "@rpath/liblua54.framework/liblua54";
#elif BF_PLATFORM_ANDROID || BF_PLATFORM_LINUX
        private const String LuaLibraryName = "liblua54.so";
#elif BF_PLATFORM_MACOS
        private const String LuaLibraryName = "liblua54.dylib";
#elif BF_PLATFORM_WINDOWS
        private const String LuaLibraryName = "lua54.dll";
#else
        #error Not supported platform.
#endif

        [Import(LuaLibraryName), CLink]
		internal static extern int32 lua_absindex(lua_State luaState, int32 idx);

		[Import(LuaLibraryName), CLink]
		internal static extern void lua_arith(lua_State luaState, int32 op);

		[Import(LuaLibraryName), CLink]
		internal static extern LuaFunction lua_atpanic(lua_State luaState, LuaFunction panicf);

		[Import(LuaLibraryName), CLink]
		internal static extern void lua_callk(lua_State luaState, int32 nargs, int32 nresults, lua_KContext ctx, LuaKFunction k);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 lua_checkstack(lua_State luaState, int32 extra);

		[Import(LuaLibraryName), CLink]
		internal static extern void lua_close(lua_State luaState);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 lua_compare(lua_State luaState, int32 index1, int32 index2, int32 op);

		[Import(LuaLibraryName), CLink]
		internal static extern void lua_concat(lua_State luaState, int32 n);

		[Import(LuaLibraryName), CLink]
		internal static extern void lua_copy(lua_State luaState, int32 fromIndex, int32 toIndex);

		[Import(LuaLibraryName), CLink]
		internal static extern void lua_createtable(lua_State luaState, int32 elements, int32 records);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 lua_dump(lua_State luaState, LuaWriter writer, void* data, int32 strip);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 lua_error(lua_State luaState);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 lua_gc(lua_State luaState, int32 what, int32 data);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 lua_gc(lua_State luaState, int32 what, int32 data, int32 data2);

		[Import(LuaLibraryName), CLink]
		internal static extern LuaAlloc lua_getallocf(lua_State luaState, ref void* ud);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 lua_getfield(lua_State luaState, int32 index, char8* k);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 lua_getglobal(lua_State luaState, char8* name);

		[Import(LuaLibraryName), CLink]
		internal static extern LuaHookFunction lua_gethook(lua_State luaState);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 lua_gethookcount(lua_State luaState);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 lua_gethookmask(lua_State luaState);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 lua_geti(lua_State luaState, int32 index, int64 i);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 lua_getinfo(lua_State luaState, char8* what, lua_Debug ar);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 lua_getiuservalue(lua_State luaState, int32 idx, int32 n);

		[Import(LuaLibraryName), CLink]
		internal static extern char8* lua_getlocal(lua_State luaState, lua_Debug ar, int32 n);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 lua_getmetatable(lua_State luaState, int32 index);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 lua_getstack(lua_State luaState, int32 level, lua_Debug n);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 lua_gettable(lua_State luaState, int32 index);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 lua_gettop(lua_State luaState);

		[Import(LuaLibraryName), CLink]
		internal static extern char8* lua_getupvalue(lua_State luaState, int32 funcIndex, int32 n);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 lua_iscfunction(lua_State luaState, int32 index);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 lua_isinteger(lua_State luaState, int32 index);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 lua_isnumber(lua_State luaState, int32 index);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 lua_isstring(lua_State luaState, int32 index);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 lua_isuserdata(lua_State luaState, int32 index);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 lua_isyieldable(lua_State luaState);

		[Import(LuaLibraryName), CLink]
		internal static extern void lua_len(lua_State luaState, int32 index);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 lua_load
		    (lua_State luaState,
		    LuaReader reader,
		    void* data,
		    char8* chunkName,
		    char8* mode);

		[Import(LuaLibraryName), CLink]
		internal static extern lua_State lua_newstate(LuaAlloc allocFunction, void* ud);

		[Import(LuaLibraryName), CLink]
		internal static extern lua_State lua_newthread(lua_State luaState);

		[Import(LuaLibraryName), CLink]
		internal static extern void* lua_newuserdatauv(lua_State luaState, uint size, int32 nuvalue);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 lua_next(lua_State luaState, int32 index);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 lua_pcallk
		    (lua_State luaState,
		    int32 nargs,
		    int32 nresults,
		    int32 errorfunc,
		    lua_KContext ctx,
		    LuaKFunction k);

		[Import(LuaLibraryName), CLink]
		internal static extern void lua_pushboolean(lua_State luaState, int32 value);

		[Import(LuaLibraryName), CLink]
		internal static extern void lua_pushcclosure(lua_State luaState, LuaFunction f, int32 n);

		[Import(LuaLibraryName), CLink]
		internal static extern void lua_pushinteger(lua_State luaState, lua_Integer n);

		[Import(LuaLibraryName), CLink]
		internal static extern void lua_pushlightuserdata(lua_State luaState, void* udata);

		[Import(LuaLibraryName), CLink]
		internal static extern char8* lua_pushlstring(lua_State luaState, char8* s, uint len);

		[Import(LuaLibraryName), CLink]
		internal static extern void lua_pushnil(lua_State luaState);

		[Import(LuaLibraryName), CLink]
		internal static extern void lua_pushnumber(lua_State luaState, lua_Number number);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 lua_pushthread(lua_State luaState);

		[Import(LuaLibraryName), CLink]
		internal static extern void lua_pushvalue(lua_State luaState, int32 index);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 lua_rawequal(lua_State luaState, int32 index1, int32 index2);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 lua_rawget(lua_State luaState, int32 index);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 lua_rawgeti(lua_State luaState, int32 index, lua_Integer n);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 lua_rawgetp(lua_State luaState, int32 index, void* p);

		[Import(LuaLibraryName), CLink]
		internal static extern uint lua_rawlen(lua_State luaState, int32 index);

		[Import(LuaLibraryName), CLink]
		internal static extern void lua_rawset(lua_State luaState, int32 index);

		[Import(LuaLibraryName), CLink]
		internal static extern void lua_rawseti(lua_State luaState, int32 index, lua_Integer i);

		[Import(LuaLibraryName), CLink]
		internal static extern void lua_rawsetp(lua_State luaState, int32 index, void* p);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 lua_resetthread(lua_State luaState);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 lua_resume(lua_State luaState, lua_State from, int32 nargs, out int32 results);

		[Import(LuaLibraryName), CLink]
		internal static extern void lua_rotate(lua_State luaState, int32 index, int32 n);

		[Import(LuaLibraryName), CLink]
		internal static extern void lua_setallocf(lua_State luaState, LuaAlloc f, void* ud);

		[Import(LuaLibraryName), CLink]
		internal static extern void lua_setfield(lua_State luaState, int32 index, char8* key);

		[Import(LuaLibraryName), CLink]
		internal static extern void lua_setglobal(lua_State luaState, char8* key);

		[Import(LuaLibraryName), CLink]
		internal static extern void lua_sethook(lua_State luaState, LuaHookFunction f, int32 mask, int32 count);

		[Import(LuaLibraryName), CLink]
		internal static extern void lua_seti(lua_State luaState, int32 index, int64 n);

		[Import(LuaLibraryName), CLink]
		internal static extern void lua_setiuservalue(lua_State luaState, int32 index, int32 n);

		[Import(LuaLibraryName), CLink]
		internal static extern char8* lua_setlocal(lua_State luaState, lua_Debug ar, int32 n);

		[Import(LuaLibraryName), CLink]
		internal static extern void lua_setmetatable(lua_State luaState, int32 objIndex);

		[Import(LuaLibraryName), CLink]
		internal static extern void lua_settable(lua_State luaState, int32 index);

		[Import(LuaLibraryName), CLink]
		internal static extern void lua_settop(lua_State luaState, int32 newTop);

		[Import(LuaLibraryName), CLink]
		internal static extern char8* lua_setupvalue(lua_State luaState, int32 funcIndex, int32 n);

		[Import(LuaLibraryName), CLink]
		internal static extern void lua_setwarnf(lua_State luaState, LuaWarnFunction warningFunctionPtr, void* ud);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 lua_status(lua_State luaState);

		[Import(LuaLibraryName), CLink]
		internal static extern uint lua_stringtonumber(lua_State luaState, char8* s);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 lua_toboolean(lua_State luaState, int32 index);

		[Import(LuaLibraryName), CLink]
		internal static extern LuaFunction lua_tocfunction(lua_State luaState, int32 index);

		[Import(LuaLibraryName), CLink]
		internal static extern LuaFunction lua_toclose(lua_State luaState, int32 index);

		[Import(LuaLibraryName), CLink]
		internal static extern lua_Integer lua_tointegerx(lua_State luaState, int32 index, out int32 isNum);

		[Import(LuaLibraryName), CLink]
		internal static extern char8* lua_tolstring(lua_State luaState, int32 index, out uint strLen);

		[Import(LuaLibraryName), CLink]
		internal static extern lua_Number lua_tonumberx(lua_State luaState, int32 index, out int32 isNum);

		[Import(LuaLibraryName), CLink]
		internal static extern void* lua_topointer(lua_State luaState, int32 index);

		[Import(LuaLibraryName), CLink]
		internal static extern lua_State lua_tothread(lua_State luaState, int32 index);

		[Import(LuaLibraryName), CLink]
		internal static extern void* lua_touserdata(lua_State luaState, int32 index);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 lua_type(lua_State luaState, int32 index);

		[Import(LuaLibraryName), CLink]
		internal static extern char8* lua_typename(lua_State luaState, int32 type);

		[Import(LuaLibraryName), CLink]
		internal static extern void* lua_upvalueid(lua_State luaState, int32 funcIndex, int32 n);

		[Import(LuaLibraryName), CLink]
		internal static extern void lua_upvaluejoin(lua_State luaState, int32 funcIndex1, int32 n1, int32 funcIndex2, int32 n2);

		[Import(LuaLibraryName), CLink]
		internal static extern lua_Number lua_version(lua_State luaState);

		[Import(LuaLibraryName), CLink]
		internal static extern void lua_warning(lua_State luaState, char8* msg, int32 tocont);

		[Import(LuaLibraryName), CLink]
		internal static extern void lua_xmove(lua_State from, lua_State to, int32 n);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 lua_yieldk(lua_State luaState,
		    int32 nresults,
		    lua_KContext ctx,
		    LuaKFunction k);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 luaL_argerror(lua_State luaState, int32 arg, char8* message);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 luaL_callmeta(lua_State luaState, int32 obj, char8* e);

		[Import(LuaLibraryName), CLink]
		internal static extern void luaL_checkany(lua_State luaState, int32 arg);

		[Import(LuaLibraryName), CLink]
		internal static extern lua_Integer luaL_checkinteger(lua_State luaState, int32 arg);

		[Import(LuaLibraryName), CLink]
		internal static extern char8* luaL_checklstring(lua_State luaState, int32 arg, out uint len);

		[Import(LuaLibraryName), CLink]
		internal static extern lua_Number luaL_checknumber(lua_State luaState, int32 arg);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 luaL_checkoption(lua_State luaState, int32 arg, char8* def, char8* [] list);

		[Import(LuaLibraryName), CLink]
		internal static extern void luaL_checkstack(lua_State luaState, int32 sz, char8* message);

		[Import(LuaLibraryName), CLink]
		internal static extern void luaL_checktype(lua_State luaState, int32 arg, int32 type);

		[Import(LuaLibraryName), CLink]
		internal static extern void* luaL_checkudata(lua_State luaState, int32 arg, char8* tName);

		[Import(LuaLibraryName), CLink]
		public static extern void luaL_checkversion_(lua_State luaState, lua_Number ver, uint sz);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 luaL_error(lua_State luaState, char8* message);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 luaL_execresult(lua_State luaState, int32 stat);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 luaL_fileresult(lua_State luaState, int32 stat, char8* fileName);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 luaL_getmetafield(lua_State luaState, int32 obj, char8* e);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 luaL_getsubtable(lua_State luaState, int32 index, char8* name);

		[Import(LuaLibraryName), CLink]
		internal static extern lua_Integer luaL_len(lua_State luaState, int32 index);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 luaL_loadbufferx
		    (lua_State luaState,
		    char8* buff,
		    uint sz,
		    char8* name,
		    char8* mode);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 luaL_loadfilex(lua_State luaState, char8* name, char8* mode);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 luaL_newmetatable(lua_State luaState, char8* name);

		[Import(LuaLibraryName), CLink]
		internal static extern lua_State luaL_newstate();

		[Import(LuaLibraryName), CLink]
		internal static extern void luaL_openlibs(lua_State luaState);

		[Import(LuaLibraryName), CLink]
		internal static extern lua_Integer luaL_optinteger(lua_State luaState, int32 arg, lua_Integer d);

		[Import(LuaLibraryName), CLink]
		internal static extern lua_Number luaL_optnumber(lua_State luaState, int32 arg, lua_Number d);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 luaL_ref(lua_State luaState, int32 registryIndex);

		[Import(LuaLibraryName), CLink]
		internal static extern void luaL_requiref(lua_State luaState, char8* moduleName, LuaFunction openFunction, int32 global);

		[Import(LuaLibraryName), CLink]
		internal static extern void luaL_setfuncs(lua_State luaState, LuaRegister* luaReg, int32 numUp);

		[Import(LuaLibraryName), CLink]
		internal static extern void luaL_setmetatable(lua_State luaState, char8* tName);

		[Import(LuaLibraryName), CLink]
		internal static extern void* luaL_testudata(lua_State luaState, int32 arg, char8* tName);

		[Import(LuaLibraryName), CLink]
		internal static extern char8* luaL_tolstring(lua_State luaState, int32 index, out uint len);

		[Import(LuaLibraryName), CLink]
		internal static extern char8* luaL_traceback
		    (lua_State luaState,
		    lua_State luaState2,
		    char8* message,
		    int32 level);

		[Import(LuaLibraryName), CLink]
		internal static extern int32 luaL_typeerror(lua_State luaState, int32 arg, char8* typeName);

		[Import(LuaLibraryName), CLink]
		internal static extern void luaL_unref(lua_State luaState, int32 registryIndex, int32 reference);

		[Import(LuaLibraryName), CLink]
		internal static extern void luaL_where(lua_State luaState, int32 level);
    }
}