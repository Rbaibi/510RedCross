from django.db import models


class Community(models.Model):
    name = models.CharField(max_length=128)
    parent = models.ForeignKey('self', on_delete=models.CASCADE, null=True, blank=True)

    class Meta:
        verbose_name_plural = 'communities'

    def __str__(self):
        return self.name


class Volunteer(models.Model):
    name = models.CharField(max_length=128)
    slug = models.SlugField(max_length=128)
    community = models.ForeignKey('Community', on_delete=models.CASCADE)
    created_on = models.DateTimeField(auto_now_add=True)
    updated_on = models.DateTimeField(auto_now=True)

    def get_points_count(self):
        p = 0
        for t in Task.objects.filter(volunteer__slug=self.slug):
            p += len(t.point_set.all())
        return p

    def __str__(self):
        return self.name


class Mission(models.Model):
    name = models.CharField(max_length=128)
    description = models.TextField()
    created_on = models.DateTimeField(auto_now_add=True)
    updated_on = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.name


class Task(models.Model):
    STATUS_CHOICES = [
        ('active', 'Active'),
        ('archived', 'Archived'),
    ]

    description = models.TextField()
    status = models.CharField(max_length=128, default='active', choices=STATUS_CHOICES)
    mission = models.ForeignKey('Mission', on_delete=models.CASCADE)
    volunteer = models.ForeignKey('Volunteer', on_delete=models.CASCADE)
    created_on = models.DateTimeField(auto_now_add=True)
    updated_on = models.DateTimeField(auto_now=True)

    def get_volunteer(self):
        return self.volunteer

    def __str__(self):
        return '{} - {}'.format(self.mission, self.volunteer)


class Point(models.Model):
    task = models.ForeignKey('Task', on_delete=models.CASCADE)
    timestamp = models.DateTimeField()
    latitude = models.FloatField()
    longitude = models.FloatField()
    depth = models.FloatField(blank=True, null=True)
    is_flooded = models.BooleanField(blank=True, null=True)

    def volunteer_name(self):
        return self.task.volunteer.name

    def __str__(self):
        return self.task.volunteer.name + " reported (%.6f, %.6f) " % (self.latitude, self.longitude) +\
               " is " + ("a flooded edge" if self.is_flooded else "not flooded") + \
               " at " + str(self.timestamp)

