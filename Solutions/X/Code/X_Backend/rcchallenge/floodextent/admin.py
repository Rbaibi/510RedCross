from django.contrib import admin
from .models import *

admin.site.register(Community)
admin.site.register(Point)

class MissionAdmin(admin.ModelAdmin):
    list_display = ('created_on', 'name',)
    ordering = ('created_on',)

class TaskAdmin(admin.ModelAdmin):
    list_display = ('created_on', 'status', 'description', 'get_volunteer',)
    ordering = ('created_on',)
    list_filter = ('volunteer__community__name',)

    Task.get_volunteer.short_description = 'Volunteer'

class VolunteerAdmin(admin.ModelAdmin):
    prepopulated_fields = {"slug": ("name",)}
    list_display = ('name', 'get_points_count')
    ordering = ('name',)
    list_filter = ('community__name',)

    Volunteer.get_points_count.short_description = 'Points'

admin.site.register(Mission, MissionAdmin)
admin.site.register(Task, TaskAdmin)
admin.site.register(Volunteer, VolunteerAdmin)
