# 2026-10-23T08:42:54.413810842
import vitis

client = vitis.create_client()
client.set_workspace(path="serious-aie-fft")

comp = client.get_component(name="central-controller-element")
comp.run(operation="C_SIMULATION")

cfg = client.get_config_file(path="/home/light/MajorProject/serious-aie-fft/central-controller-element/hls_config.cfg")

cfg.set_value(key="part", value="xa7z030fbg484-1I")

comp.run(operation="C_SIMULATION")

vitis.dispose()

