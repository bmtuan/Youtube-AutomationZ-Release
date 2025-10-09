import atexit

from nicegui import ui

from src.route_manager import router
from web.components.loop import cleanup_tkinter_root
from web.views import *

router.setup_routes()

# Register cleanup function to be called on application shutdown
atexit.register(cleanup_tkinter_root)

ui.run(
    title="Automation Z",
    favicon="https://cdn-icons-png.flaticon.com/512/8188/8188078.png",
    port=8081,
)
)
