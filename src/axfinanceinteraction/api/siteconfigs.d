module axfinanceinteraction.api.siteconfigs;

import std.stdio, std.system, std.string, std.path;
import ax.application.configs;
import ax.application.parentconfigs;
import axfinanceinteraction.api.paths;
import toml.d;
import vibe.data.json;
/**
	Класс костыль, для хранение конфигурации сайта
*/
class SiteConfigs: ax.application.parentconfigs.ParentConfigs!(TOMLValue)
{
	public:
		this(in string pCfgDir, in string exName, in string en = "settings.toml")
    	{
    		configName(en);
    		pathDirectory(buildPath(pCfgDir, exName));
    		auto pathToEx = buildPath(pathDirectory(), configName());
			auto exConf = parseFile(pathToEx);
			auto конфиг = parseFile(buildPath(pCfgDir, "a_base", configName()));
			apis = parseFile(buildPath(pathDirectory(), "api" , "private.toml"));
    		auto NameEx = "Name" in exConf["API"]["Path"] ? exConf["API"]["Path"]["Name"].str : exName;
    		if (("key" !in exConf["API"]["Keys"]) || ("secret" !in exConf["API"]["Keys"])) return;
    		key(exConf["API"]["Keys"]["key"].str);
    		secret(exConf["API"]["Keys"]["secret"].str);
    		auto prPath = getValue("Private", конфиг["API"]["Path"], exConf["API"]["Path"]);
    		auto comm = getValue("Common", конфиг["API"]["Path"], exConf["API"]["Path"]);
    		auto comVers = getValue("CommonVersion", конфиг["API"]["Path"], exConf["API"]["Path"]);
    		auto prSeq = getValue("PrivateSeq", конфиг["API"]["Path"], exConf["API"]["Path"]).to!bool;
    		auto prMeth = getValue("PrivateMethod", конфиг["API"]["Path"], exConf["API"]["Path"]).to!bool;
			dp = Paths(NameEx, comm, comVers, prPath, prSeq, prMeth);/**/
    	}
    	string key()
    	{
    		return ke;
    	}
    	string secret()
    	{
    		return se;
    	}
    	string fullPath(in string ss)
    	{
    		return dp.full(apiValue(ss));
    	}
		string apiValue(in string b)
    	{
    		return apis[b].str;
    	}
	private:

    	bool key(in string kk)
    	{
    		ke = kk;
    		return true;
    	}
    	bool secret(in string ss)
    	{
    		se = ss;
    		return true;
    	}

    	TOMLValue apis;
    	Paths dp;
    	string ke;
    	string se;
}
