name             'flashcards'
maintainer       'Nikolay Malinin'
maintainer_email 'ne9zzz@gmail.com'
license          'All rights reserved'
description      'Installs/Configures flashcards'
long_description ""
version          '1.0.0'

recipe 'flashcards::default'

depends 'build-essential'
depends 'ruby_build'
depends 'user'
depends 'postgresql', '~> 3.4.18'
depends 'yum'

supports 'centos'
