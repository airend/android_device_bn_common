import common

def SystemResize(info):
  if not SystemResize.ran_once:
    e2fsck = '"/sbin/e2fsck", "-fy"'; run_prog = 'run_program('
    _, sys_dev = common.GetTypeAndDevice("/system", info.info_dict)
    sys_dev = ', "' + sys_dev + '");'
    try:
      resize2fs = '"/tmp/' + \
        info.input_zip.getinfo("install/bin/resize2fs_static").filename + '"'
    except:
      resize2fs = '"/sbin/resize2fs"'
    info.script.AppendExtra(run_prog + e2fsck + sys_dev)
    info.script.AppendExtra(run_prog + resize2fs + sys_dev)
    info.script.AppendExtra(run_prog + e2fsck + sys_dev)
    SystemResize.ran_once = True

SystemResize.ran_once = False

def FullOTA_PostValidate(info):
  SystemResize(info)

def FullOTA_InstallEnd(info):
  SystemResize(info)
