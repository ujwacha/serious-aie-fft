# 2026-11-08T09:43:16.696163324
import vitis

client = vitis.create_client()
client.set_workspace(path="serious-aie-fft")

comp = client.get_component(name="fft_accelerator_component")
comp.build(target="x86sim")

comp.build(target="x86sim")

comp.build(target="x86sim")

vitis.dispose()

