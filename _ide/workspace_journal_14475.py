# 2026-10-21T08:56:55.931961407
import vitis

client = vitis.create_client()
client.set_workspace(path="serious-aie-fft")

comp = client.create_aie_component(name="aie_component", part = "xa7z010clg225-1I", template = "empty_aie_component")

vitis.dispose()

