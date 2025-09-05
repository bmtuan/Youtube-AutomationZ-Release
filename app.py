from nicegui import ui

from src.route_manager import router
from web.views import *

router.setup_routes()

ui.run(
    title="Automation Z",
    favicon="https://cdn-icons-png.flaticon.com/512/8188/8188078.png",
    port=8081,
)
