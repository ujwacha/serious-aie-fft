# 2026-10-21T09:01:21.395296803
import vitis

client = vitis.create_client()
client.set_workspace(path="serious-aie-fft")

comp = client.get_component(name="aie_component")
comp.build(target="x86sim")

