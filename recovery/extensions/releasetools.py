import common

def SystemResize(info):
  if not SystemResize.ran_once:
    sys_dev = '"' + common.OPTIONS.info_dict["fstab"]["/system"].device + '"'
    run = 'run_program('; e2fsck = '"/sbin/e2fsck", "-fy"'
    try:
      resize2fs = '"/tmp/' + \
        info.input_zip.getinfo("install/bin/resize2fs_static").filename + '"'
    except:
      resize2fs = '"/sbin/resize2fs"'
    info.script.AppendExtra(run + e2fsck + ', ' + sys_dev + ');')
    info.script.AppendExtra(run + resize2fs + ', ' + sys_dev + ');')
    info.script.AppendExtra(run + e2fsck + ', ' + sys_dev + ');')
    SystemResize.ran_once = True

SystemResize.ran_once = False

def FullOTA_PostValidate(info): SystemResize(info)

def FullOTA_InstallEnd(info): SystemResize(info)
