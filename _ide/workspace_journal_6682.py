# 2026-11-08T09:51:29.909610563
import vitis

client = vitis.create_client()
client.set_workspace(path="serious-aie-fft")

comp = client.get_component(name="aie_component")
comp.build(target="x86sim")

vitis.dispose()

vitis.dispose()

