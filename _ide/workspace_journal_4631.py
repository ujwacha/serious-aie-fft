# 2026-10-30T08:41:48.039072170
import vitis

client = vitis.create_client()
client.set_workspace(path="serious-aie-fft")

comp = client.get_component(name="central-controller-element")
comp.run(operation="C_SIMULATION")

comp.run(operation="SYNTHESIS")

cfg = client.get_config_file(path="/home/light/MajorProject/serious-aie-fft/central-controller-element/hls_config.cfg")

cfg = client.get_config_file(path="/home/light/MajorProject/serious-aie-fft/central-controller-element/hls_config.cfg")

cfg = client.get_config_file(path="/home/light/MajorProject/serious-aie-fft/central-controller-element/hls_config.cfg")

cfg = client.get_config_file(path="/home/light/MajorProject/serious-aie-fft/central-controller-element/hls_config.cfg")

cfg = client.get_config_file(path="/home/light/MajorProject/serious-aie-fft/central-controller-element/hls_config.cfg")

cfg.set_value(section="hls", key="syn.csimflags", value="")

cfg.set_value(section="hls", key="syn.cflags", value="")

cfg.set_values(key="syn.file_cflags", values=[])

cfg.set_values(key="syn.file_csimflags", values=[])

cfg.set_values(key="syn.file", values=["./src/main.h", "./src/main.cpp", "./src/hamming.h"])

cfg.set_value(section="hls", key="syn.top", value="kernel")

cfg.set_value(section="hls", key="syn.top", value="kernel")

comp.run(operation="SYNTHESIS")

comp.run(operation="SYNTHESIS")

comp.run(operation="SYNTHESIS")

comp.run(operation="SYNTHESIS")

comp.run(operation="SYNTHESIS")

comp.run(operation="SYNTHESIS")

comp.run(operation="SYNTHESIS")

comp.run(operation="SYNTHESIS")

comp.run(operation="SYNTHESIS")

comp.run(operation="SYNTHESIS")

comp.run(operation="SYNTHESIS")

comp.run(operation="SYNTHESIS")

vitis.dispose()

