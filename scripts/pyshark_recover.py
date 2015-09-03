#!/bin/python

import os
import sys
import csv
import argparse
import requests


URI = 'http://playlist.fish/api'

description = 'Download your Grooveshark playlists as CSV.'
parser = argparse.ArgumentParser(description=description)
parser.add_argument('USER', type=str, help='Grooveshar user name')
args = parser.parse_args()
user = args.USER

with requests.Session() as session:
    # Login as user
    data = {'method': 'login', 'params': {'username': user}}
    response = session.post(URI, json=data).json()
    if not response['success']:
        print('Could not login as user "%s"! (%s)' %
              (user, response['result']))
        sys.exit()

    # Get user playlists
    data = {'method': 'getplaylists'}
    response = session.post(URI, json=data).json()
    if not response['success']:
        print('Could not get "%s" playlists! (%s)' %
              (user, response['result']))
        sys.exit()

    # Save to CSV
    playlists = response['result']
    if not playlists:
        print('No playlists found for user %s!' % user)
        sys.exit()
    path = './pysharkbackup_%s' % user
    if not os.path.exists(path):
        os.makedirs(path)
    for p in playlists:
        plid = p['id']
        name = p['n']
        data = {'method': 'getPlaylistSongs', 'params': {'playlistID': plid}}
        response = session.post(URI, json=data).json()
        if not response['success']:
            print('Could not get "%s" songs! (%s)' %
                  (name, response['result']))
            continue
        playlist = response['result']
        f = csv.writer(open(path + '/%s.csv' % name, 'w'))
        f.writerow(['Artist', 'Album', 'Name'])
        for song in playlist:
            f.writerow([song['Artist'], song['Album'], song['Name']])
