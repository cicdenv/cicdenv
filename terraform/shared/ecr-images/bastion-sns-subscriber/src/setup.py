from setuptools import setup, find_packages

setup(
    name='bastion-sns-subscriber',
    version="1.0",
    packages=find_packages(),
    py_modules=['sns'],
    include_package_data=True,
    install_requires=[
        'Flask',
        'boto3',
        'requests',
    ],
    entry_points='''
        [console_scripts]
        bastion-sns-subscriber=main:cli
    ''',
)
