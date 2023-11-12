<%block name="main">\
<%
# Which approach would you like to use for monitor's connection with observers(scoreboard,coverage etc.)?
#     1) Callbacks approach ;
#     2) Analysis port usage in monitor
self.mon2cov_con_approach = "callback"
%>\
`ifndef ${agent_name.upper()}_MON_2COV_CONNECT
`define ${agent_name.upper()}_MON_2COV_CONNECT

% if (self.mon2cov_con_approach == "callback") :
class ${agent_name}_mon2cov_connect extends MON_callbacks;

   ${agent_name}_cov cov;

   function new(${agent_name}_cov cov);
      this.cov = cov;
   endfunction: new
   // Callback method post_cb_trans can be used for coverage
   virtual task post_cb_trans(${agent_name}_mon xactor,
                              ${agent_name}_tr tr);
      cov.tr = tr;
      -> cov.cov_event;

   endtask: post_cb_trans
% endif
% if (self.mon2cov_con_approach == "analysis_port") :
class ${agent_name}_mon2cov_connect extends uvm_component;
   ${agent_name}_cov cov;
   uvm_analysis_export # (${agent_name}_item) an_exp;
   `uvm_component_utils(${agent_name}_mon2cov_connect)
   function new(string name="", uvm_component parent=null);
   	super.new(name, parent);
   endfunction: new

   virtual function void write(${agent_name}_item tr);
      cov.tr = tr;
      -> cov.cov_event;
   endfunction:write 
% endif

endclass: ${agent_name}_mon2cov_connect
`endif // ${agent_name.upper()}_MON_2COV_CONNECT
</%block>