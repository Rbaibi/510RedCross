from django.core.exceptions import SuspiciousOperation
from django.views.generic import FormView
from django.views.decorators.csrf import csrf_exempt
from django.views.generic.list import BaseListView
from django.views.generic import TemplateView
from django.http import JsonResponse
import json
from .models import Task, Volunteer, Point
from django.utils.text import slugify
from django.utils.decorators import method_decorator

from django.utils.dateparse import parse_datetime
from django.utils.timezone import is_aware, make_aware


def get_aware_datetime(date_str):
    ret = parse_datetime(date_str)
    if not is_aware(ret):
        ret = make_aware(ret)
    return ret

# TODO:
# - Replace usage of SuspiciousOperation by a subclass


class TaskView(BaseListView):
    model = Task

    def get_queryset(self):
        volunteer = slugify(self.request.GET.get('volunteer'))

        if volunteer is None:
            raise SuspiciousOperation()

        try:
            volunteer = Volunteer.objects.get(slug=volunteer)
        except Volunteer.DoesNotExist:
            raise SuspiciousOperation()

        tasks = Task.objects.filter(
            volunteer=volunteer,
        )

        status = self.request.GET.get('status')
        if status is not None:
            tasks = tasks.filter(status=status)

        return tasks.order_by('id')

    def get(self, request, *args, **kwargs):

        self.object_list = self.get_queryset()

        tasks = []
        for task in self.object_list:
            tasks.append({
                'id': task.id,
                'task': task.description,
                'status': task.status,
                'mission_id': task.mission.id,
                'mission_name': task.mission.name,
                'mission_description': task.mission.description,
            })

        return JsonResponse(tasks, safe=False, **kwargs)


class PointView(FormView):
    model = Point

    def post(self, request, *args, **kwargs):

        # print(request.body)

        data = json.loads(request.body.decode('utf-8'))

        tasks = Task.objects.filter(
            id=kwargs['id']
        )
        if len(tasks) != 1 or tasks[0] is None:
            raise SuspiciousOperation()

        def get_point_from_json(point_struct):
            datetime_str = point_struct["timestamp"]
            timestamp = get_aware_datetime(datetime_str)
            if timestamp is None:
                raise SuspiciousOperation()

            latitude = point_struct["latitude"]
            if latitude is None:
                raise SuspiciousOperation()

            longitude = point_struct["longitude"]
            if longitude is None:
                raise SuspiciousOperation()

            depth = point_struct["depth"]
            if depth is None:
                depth = 0

            is_flooded = point_struct["is_flooded"]
            if is_flooded is None:
                raise SuspiciousOperation()

            return Point.objects.create(timestamp=timestamp, task=tasks[0],
                                        latitude=latitude, longitude=longitude,
                                        depth=depth, is_flooded=is_flooded)

        for point_struct in data:
            point = get_point_from_json(point_struct)
            point.save()

        return JsonResponse({})

    @method_decorator(csrf_exempt)
    def dispatch(self, request, *args, **kwargs):
        return super(PointView, self).dispatch(request, *args, **kwargs)


class MapView(TemplateView):

    # def get(self, request, *args, **kwargs):
    #     points = Point.objects.all()
    #     return render(request, "map.html", context=points)

    template_name = 'map.html'

    def get_context_data(self, *args, **kwargs):
        context = {}
        context['points'] = Point.objects.all()
        return context