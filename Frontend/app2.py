import requests


image_path = "temp_CAP3852210285656182050.jpg"

user_id = "19"

url = "https://mmm12212.pythonanywhere.com/send_image"

with open(image_path, 'rb') as image_file:
    files = {
        'file': (image_path, image_file, 'image/jpeg')
    }
    # Send user_id as a form field, not in 'data' (use 'data' for form fields)
    data = {
        'user_id': str(user_id)  # Ensure user_id is a string
    }

    response = requests.post(url, files=files, data=data)

    try:
        response.raise_for_status()
        print("✅ Success:", response.json())
    except requests.exceptions.HTTPError as err:
        print("❌ HTTP Error:", err)
        print("Response content:", response.text)
    except Exception as e:
        print("❌ Error:", e)