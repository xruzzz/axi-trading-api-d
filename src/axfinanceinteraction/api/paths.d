module axfinanceinteraction.api.paths;

import std.stdio, std.system, std.path;
import vibe.data.json;

struct Paths
{
	public:
    	this(in string nnmm, in string apPath, in string comVerss, in string pPr, in bool pp = false, in bool mm  = false)
    	{
    		fqdn(nnmm ~ ".com");
    		apiPath(apPath);
    		commonVersion(comVerss);
    		pathPrivate(pPr);
    		usePublic = pp;
    		methodAfterPrivate = mm;
    	}
    	@property string full(in string fun)
    	{
    		return "https://"~buildPath(fqdn(), apiPath(),commonVersion(), pathRequest(fun));
    	}
	private:
		string apiPath()
    	{
    		return usePublic ? apP :"";
    	}
		bool apiPath(in string vv)
    	{
    		apP = vv;
    		return true;
    	}
		string commonVersion()
    	{
    		return usePublic ?cv :"";
    	}
		bool commonVersion(in string vv)
    	{
    		cv = vv;
    		return true;
    	}
	    bool path(in string ff)
    	{
    		pa = ff;
    		return true;
    	}
    	string path()
    	{
    		return pa;
    	}
    	bool pathPrivate(in string ff)
    	{
    		paPr = ff;
    		return true;
    	}
	    string pathPrivate()
    	{
    		return paPr;			
    	}
	    string pathRequest(in string b)
    	{
			return methodAfterPrivate ? buildPath(pathPrivate(), b) : pathPrivate;	
    	}
		string fqdn()
    	{
    		return fq;
    	}
		bool fqdn(in string ff)
    	{
    		fq = ff;
    		return true;
    	}
		bool usePublic;
    	bool methodAfterPrivate;
    	string paPr;
    	string pa;
    	string apP;
    	string cv;
    	string nm;
    	string td;
    	string fq;
}
