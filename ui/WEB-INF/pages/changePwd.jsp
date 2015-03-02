<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
	$(document).ready(function() {
		var baseDiv = "form_modal";
		fObject("dialog_tabs", baseDiv).find("a:eq(0)").tab("show");
		fObject("confrim", baseDiv).click(function() {
			$("#changePwd_form").vali_Form();
			if ($("#changePwd_form").hasError()) {
				return;
			}
			hideForm();
			var paramObj = parseParamObj($("#changePwd_form").find("[name]"));
			// md5 加密 twice
			paramObj.user_password_new = $.md5(b64_sha512(paramObj.user_password_new));
			paramObj.user_password = $.md5(b64_sha512(paramObj.user_password));
			commonAjax_pro("/changePwdConfrim.do", paramObj, function(msg) {
				processStop();
				var array = msg.split("|");
				if (array[0] === '0') {
					alertMsg_B("保存成功");
					fObject('refresh_button', 'main_area').click();
				} else {
					if (array[1]) {
						alertMsg_B("保存失败," + array[1]);
					} else {
						alertMsg_B("保存失败");
					}
				}
			});
		});
		// 修改时特殊需要处理
		if ('${mod_flag}' === '1') {
			fObject("user_id", baseDiv).removeAttr("validation");
			fObject("user_id", baseDiv).attr("readonly", true);
			$("#" + baseDiv + " [for='user_password']").append("<span class='label label-info mg-l-5'>不录入视为不更改</span>");
		}
		$("#changePwd_form [validation]").change(function() {
			$(this).vali_Ele();
		});
		$("#changePwd_form [validation]").blur(function() {
			$(this).vali_Ele();
		});
		//密码特殊样式绑定,用attr("class")有问题
		fObject("password_icon", baseDiv).parent().click(function() {
			if (fObject("password_icon", baseDiv).hasClass("icon-eye-open")) {
				fObject("user_password_new", baseDiv).attr("type", "password");
				fObject("password_icon", baseDiv).attr("class", " icon-eye-close");
			} else {
				fObject("user_password_new", baseDiv).attr("type", "text");
				fObject("password_icon", baseDiv).attr("class", " icon-eye-open");
			}
		});
	});
</script>
<div class="modal-content">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		<h4 class="modal-title">修改密码</h4>
	</div>
	<div class="modal-body">
		<form id="changePwd_form" class="" role="form">
			<div id="dialog_basic">
				<div class="form-group ">
					<label class="control-label" for="user_password">原始密码</label> <input class="form-control input-group" name="user_password"
						type="password" placeholder="请输入原始密码" validation="required" value="">

				</div>
				<div class="form-group ">
					<label class="control-label" for="user_password_new">新密码</label>
					<div class="input-group" name="password_div">
						<input class="form-control input-group" name="user_password_new" type="text" placeholder="请输入新密码"
							validation="required|password|maxlen=20|minlen=5" value=""><span class="input-group-addon"><i class=" icon-eye-open"
							name="password_icon"></i></span>
					</div>
				</div>
			</div>
		</form>
	</div>
	<div class="modal-footer">
		<button type="button" class="btn btn-primary" name="confrim">确定</button>
		<button type="button" class="btn btn-default" data-dismiss="modal" name="cancel">取消</button>
	</div>
</div>