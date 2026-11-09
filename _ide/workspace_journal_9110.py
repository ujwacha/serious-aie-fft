# 2026-10-21T12:55:24.500919941
import vitis

client = vitis.create_client()
client.set_workspace(path="serious-aie-fft")

comp = client.get_component(name="aie_component")
comp.build(target="x86sim")

comp.build(target="x86sim")

comp.build(target="x86sim")

comp.build(target="x86sim")

comp.build(target="x86sim")

comp.build(target="x86sim")

vitis.dispose()

