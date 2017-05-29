(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-baseimage:x86_64-0.1.0
docker tag hyperledger/fabric-baseimage:x86_64-0.1.0 hyperledger/fabric-baseimage:latest

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin")   open http://localhost:8080
            ;;
"Linux")    if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                 xdg-open http://localhost:8080
	        elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
                       #elif other types bla bla
	        else   
		            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
            ;;
*)          echo "Playground not launched - this OS is currently not supported "
            ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� 0-,Y �]o�0���ᦀC(�21�BJ�AI`�U��K�G˦���)���u��M��r�k���c��"M;�� B�����H����.\^���!�"�	� ��ӣ��� k �(e�(� ��X)�N�^�����D8�%P���"DRl�H:�Cފ�Hj�' �g��6�9kD��֊`��S>]��^�	[���	J1z�F����� h��%��J���l�O1	|��A4��ײ�kˡ9���g�kE�c��LF�ֳ|G�EK�i_�9D��)ZȢ���M`6�h�0[�h�M��J��&�sY���h�ɺ>X�H6�qX�^���D���df�?I�v;�H�$~�ɶs+��� E�'����KY���Ÿ���Q�&��1�<1eZ�9���8��	��V����].��qW�*��*
]W���,-�HG5��O�BO׾%����.�rQ�\FдA#r
��G����� ;d�H7�Pn���I'*�;�����%h���]� �ʖ��WPb�F��y:ZlE��\�i���f2������_ �������fN�{좨.T�q_vh�C}��!j?hΏ�l�C�
&�=$�dC@Jw{y\L������]Z�$Ӵ7���yn���	rhV��F�IvY��P��MaӭIh�|���	X/��c�@e-Ji�ɪR/V�-t����R,BXa?PAT�<瞞�u�%�M�g����Gq���}��鷞~���U���p8���p8���p8���p�&? �Kj (  