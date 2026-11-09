# 2026-11-08T09:35:21.212721035
import vitis

client = vitis.create_client()
client.set_workspace(path="serious-aie-fft")

comp = client.get_component(name="aie_component")
comp.build(target="x86sim")

comp = client.create_aie_component(name="fft_accelerator_component", part = "xa7z010clg225-1I", template = "empty_aie_component")

comp = client.get_component(name="fft_accelerator_component")
comp.build(target="x86sim")

comp.build(target="x86sim")

status = comp.update_top_level_file(top_level_file="/home/light/MajorProject/serious-aie-fft/fft_accelerator_component/src/graph.cpp")

status = comp.update_part(part="")

vitis.dispose()

