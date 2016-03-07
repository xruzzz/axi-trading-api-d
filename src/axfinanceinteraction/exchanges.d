module axfinanceinteraction.exchanges;

import std.stdio, std.system, std.string, std.datetime, std.path, std.process;
import axfinanceinteraction.api.siteconfigs, axfinanceinteraction.api.privates;
import vibe.data.json;
alias exapi = axfinanceinteraction.api;
/**
	Класс для управления биржами
*/
class Exchanges
{
	public:
		this(in string org, in string sysname, in string appName, in string nameEx)
    	{
    		auto home = environment["HOME"];			// version Linux
    		pathConfigDir(buildPath(home, "."~org, sysname, appName, "exchanges"));
			sit = new exapi.siteconfigs.SiteConfigs(pathConfigDir, nameEx);
    	}
    	bool setResponse(Json jj)
    	{
    		resp = jj;
    		return true;
    	}
    	string getFormatRequest(string met)
    	{
    		auto st = Clock.currTime(UTC());
    		return format("method=%s&nonce=%s", sit.apiValue(met), st.toUnixTime());
    	}
    	double getCurrency(string name)
    	{ 
    		double res;// = to!double(resp["return"][pi.availableFunds][name].get!double);//to!double(resp[pi.lockedFunds][name].get!string) + 
    		return res;
    	}
    	double getAmountCurrency(string name)
    	{ 
    		double res;// = to!double(resp[pi.availableFunds][name].get!string)+to!double(resp[pi.lockedFunds][name].get!string);
    		return res;
    	}
    	bool listOrderPairs()
    	{ 
    		int [string] sta;
    		auto i = 0;
    		foreach (el ; resp["orders"])
    		{
    			sta [el["pair"].get!string] ++;
    			i++;
    			writeln(" #  ", i, "  ", el["pair"].get!string);
    		}
    		i = 0;

    		writeln(" # sta  ", sta);
    		foreach (el ; std.algorithm.sort(sta.keys))
    		{
    			i++;
    			writeln(" #  ", i, "  ", el);
    		}
    		//writeln(" #end#  ", sta.keys.sort);
    		return true;
    	}
		string fullPath(in string meths)
    	{
    		return sit.fullPath(meths);
    	}
    	SiteConfigs sit;
	private:

    	bool pathConfigDir(in string ss)
    	{
    		pCfgDir = ss;
    		return true;
    	}
    	string pathConfigDir()
    	{
    		return pCfgDir;
    	}
    	bool homeName(in string nn)
    	{
    		hm = nn;
    		return true;
    	}
    	string homeName()
    	{
    		return hm;
    	}
    	
		Json resp;
		string pCfgDir;
		string hm;
}
