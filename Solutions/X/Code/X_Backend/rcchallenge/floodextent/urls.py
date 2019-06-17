from django.urls import path
from .views import PointView, TaskView, MapView

urlpatterns = [
    path('tasks/', TaskView.as_view()),
    path('tasks/<int:id>/points', PointView.as_view()),
    path('admin/floodextent/map/', MapView.as_view()),
]
