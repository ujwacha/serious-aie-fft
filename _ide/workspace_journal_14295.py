# 2026-10-22T15:53:57.242222151
import vitis

client = vitis.create_client()
client.set_workspace(path="serious-aie-fft")

cfg = client.get_config_file(path="/home/light/MajorProject/serious-aie-fft/central-controller-element/hls_config.cfg")

cfg = client.get_config_file(path="/home/light/MajorProject/serious-aie-fft/central-controller-element/hls_config.cfg")

cfg = client.get_config_file(path="/home/light/MajorProject/serious-aie-fft/central-controller-element/hls_config.cfg")

cfg.set_value(section="hls", key="syn.csimflags", value="")

cfg = client.get_config_file(path="/home/light/MajorProject/serious-aie-fft/central-controller-element/hls_config.cfg")

cfg = client.get_config_file(path="/home/light/MajorProject/serious-aie-fft/central-controller-element/hls_config.cfg")

cfg.set_value(section="hls", key="syn.cflags", value="")

cfg.set_values(key="syn.file_cflags", values=[])

cfg.set_values(key="syn.file", values=["./src/main.h"])

cfg.set_values(key="syn.file_csimflags", values=[])

cfg.set_value(section="hls", key="syn.cflags", value="")

cfg.set_value(section="hls", key="syn.csimflags", value="")

cfg.set_values(key="syn.file", values=["./src/main.h", "./src/main.cpp"])

cfg.set_values(key="syn.file_csimflags", values=[])

cfg.set_values(key="syn.file_cflags", values=[])

cfg.set_value(section="hls", key="syn.top", value="add_vec")

cfg.set_value(section="hls", key="syn.cflags", value="")

cfg.set_value(section="hls", key="syn.csimflags", value="")

cfg.set_values(key="syn.file_csimflags", values=[])

cfg.set_values(key="syn.file", values=["./src/main.h", "./src/main.cpp"])

cfg.set_values(key="syn.file_cflags", values=[])

cfg.set_value(section="hls", key="tb.cflags", value="")

cfg.set_value(section="hls", key="syn.csimflags", value="")

cfg.set_values(key="tb.file", values=["./tb"])

cfg.set_values(key="tb.file_cflags", values=[])

comp = client.get_component(name="central-controller-element")
comp.run(operation="C_SIMULATION")

cfg.set_value(section="hls", key="tb.cflags", value="")

cfg.set_value(section="hls", key="syn.csimflags", value="")

cfg.set_values(key="tb.file", values=[])

cfg.set_values(key="tb.file_cflags", values=[])

cfg.set_value(section="hls", key="tb.cflags", value="")

cfg.set_value(section="hls", key="syn.csimflags", value="")

cfg.set_values(key="tb.file_cflags", values=[])

cfg.set_values(key="tb.file", values=["./tb/test.cpp"])

comp.run(operation="C_SIMULATION")

comp.run(operation="C_SIMULATION")

comp.run(operation="C_SIMULATION")

comp.run(operation="C_SIMULATION")

comp.run(operation="SYNTHESIS")

comp.run(operation="SYNTHESIS")

comp.run(operation="CO_SIMULATION")

