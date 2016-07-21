global with sharing class cc_lol_ctrl_ProductListInclude {
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getProductPrice(final ccrz.cc_RemoteActionContext ctx) {
        
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult(); 
        res.success = true;
        res.data = 1020.78;        
        return res;
        }
}