import requests
import sys
import json

#image_path = r"C:\Users\ethan\Documents\GitHub\AV-AHK\Images\Story\Waves2\Wave5.png"
def test(image_path, webhook_url, current_version, time_elapsed):
    #image_path = r"C:\Users\ethan\Documents\GitHub\AV-AHK\Images\Story\Waves2\Wave5.png"
    #with open(image_path, 'rb') as f:
    #    image_data = f.read()

    payload_json = {
        "embeds": [{
            "author": {
                "name": "InformaalFrog Macro Alert",
                "icon_url": "https://media.discordapp.net/attachments/1058152472536940659/1283843219804782633/lgow.png"
            },
            "title": "Map Completed",
            "color": 16738740,
            "image": {"url": "attachment://gameScreenshot.png"},
            "fields": [
                {"name": "Time Elapsed", "value": time_elapsed, "inline": True}
            ],
            "footer": {
                "text": f"InformaalFrog AV Macro | {current_version}",
                "icon_url": "https://cdn.discordapp.com/attachments/1058152472536940659/1283843219804782633/lgow.png"
            }
        }]
    }

    files = {
        'payload_json': (None, json.dumps(payload_json), 'application/json'),
        #'file': ('image.png', image_data)
        'files[0]': ('gameScreenshot.png', open(image_path, 'rb'), 'image/png')
    }

    requests.post(webhook_url, files=files)

#test(image_path)

if __name__ == "__main__":
    # Get parameters from command line arguments
    image_path = sys.argv[1]
    webhook_url = sys.argv[2]
    current_version = sys.argv[3]
    time_elapsed = sys.argv[4]

test(image_path, webhook_url, current_version, time_elapsed)