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
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else   
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� 0-,Y �][s���g~�u^��'�~���:�MQAAD�ԩwo����j��e2���=��o&A��^�ַVgu��d_��2���OR�����I���_PEq���_�p�K����<�&[�i��e���i�r�����p�?������rz���x�}Ȉ�\�M`����k�=���@�X�B�J�%���?�x�9�\�(I������{�+��[G���'�J���/���u������O�4^ɿ\���:�2�L��O��Q�Ta��d��X�{��X@P����|R{�N�i�V��(>F�i�v1w��<��)��Q��Q�b��q�e����Q��HsmǣHE��o��{~�2���x���$�������/5��������ؐ՚�}P��	���S�4]h�(�H��&��I����V���l5�M[�Ta&��~ʧ1�<�j���@.6�&h!�S�J�MJO��<�Mt��h�C����@O�{<e��t�����24H���ֶޗ�.��P�Ȗ(z9�����tj��
/=���ѿ)~I�m/�.]?]�<0����
�����G�������:��x����=��R��R����nȒ�f����2�4x���2BYS����ޖr<k.�m�h�ͅ�j2�u{�&�*Z�C�f	��5ļe��7�@�9��aRf�[7"��
��ʸ��0i#��=də=Rg�A���?<Qd�a.�9�ĝh��&�or���s#w�p�W%W�ǃ�(f<�8'������Ď��L�4��x :t�rh�su�4���6�P�I308���`eS��F���c�[q ~�,]̅��/��O����xk��X��?�&��B�7�D��bD(m����|7�Ȕ�	Ӱ��X�1je�>�����f9+�d�r�v���,7Gq�;S��kQ�с�@��r��sM<�<��ީ������B���J�ϕ%(��}��t9^eu�Ș��6|#;��a��l�E�$m.o4F�t�4W���%�(‗5����e�Ob`���1f��:���a�����w�\��$mIm45Q�u�!�%�H�X4�9����l���܆g�����r�K�?��o����?�U�_
>H���?�^��)�c(AV�_^�qV�����#ü�ީ��.Yo	$��-����9ǉP�1�%�
��Q�N����٩pP�8*�*Hvq��~�Wf��9E�w���7��0EWrH<�0��'�5�%��;�b��V.�SYS�Q���lM�HM\L�ޕC�f�ߛe�.�i���ռ��"ľ�@h�}�].?���gᲭN�ȅ�D�=�5an[8�ȑ�[���9k@@H\^��!��
 y;?]d��Z.� ����>kr���r�Mwp�x/��-��))�D"�a�t�zr�a�:D��K}0�m�`B2���q���D���ϛX��X��Q���o�m������}?��Z2��h�Y�!���:��x��_�������H���("���_��#MT�_����������~���9'�r�/"B���2�K�������+U�O�����O��$�^@�lqt�"���a��a���]sY��(?pQ2@1g=ҫ��.�!�W���P^�e������qG��V�4��e��,��h\�o����b��Z6�`۶�17�ij��ɗ޲���f�V_r̹�4p�N�#ڃ967�hk�� ����V��(A��f)�Ӱ��y/~I�?3����/%���A*�_���j��������e�?3����R�A�t�C�����-�gz����C��!|��l����:�f��w�бY��{�Ǧ��|h ���N����p\�� ��I��!&��{SinM�	����0w�s��t��$��P�s��m6�7�y�ֻ� 
�4%
��<.t��ʝ��1vL���k̑��#�r68f$�{������[�i��H �B�0$�@ ��7PĖ �!/X��k�N8a7E�j�de:�� �n��;���GӞ=4�*���TQ��w{�χf=�/��$d�����f�u��LiYZw4�C^nvL5QBډI�H�,E�vC2�	\��d�Ѓ������%����?h��e�C���?���*����*��s��7��~�`��?�����K��
Ϳ���#P���RP��������;����c_� ����*���q	�{�M:x������Юoh�a8�zn��(°J",�8, �Ϣ4K��]e��~(C����!4AU�_� �Oe®ȯV+U���؜����=�i�m����?��)����H�	�S����;����^����=��n�c�Vi�ہ�8"��	�y� ���`�ʇ7y��)%�v�Y���n<��8���÷��8�Gi���/o��������?T��w9�P���/3
��'�J�K�{�����˗����q��_>R�/-�X��k�Z�[
~��G�������2�)���]��,F,�8�M��M��
��b������,����,��h5QTʐ���?8r������|\0��Et�RKD�D�ń���6�F��w9W���i�~�~q�g5�	^�뺻�V��KQ=�#r�1v��2��-ptˇ`�Oe��4v��U뙈k���6H0{0��j����H�i9�;�?���R�;�(I<��(���2�I�����l�
e�������4��@���J�k�_�c������s Vrt�"^c	K ��o����>z�gI ����1v?n���IUZ.�wIU��72���F�o��a=������@C��~شs�ā�ɧ>;�S�żx��Զ�1���t�o�0��"F�E7Ӭ����	5��D�Xo�Ql�f:Gm᭸h.)�74L��(g=�@�p[�G1��#�Fz�H��9}��H,̹����p�wk�ʹ�Q�њ����)�,Ԧϩ��;�t�3r�¼�kԥΈ$������>X�.k�����9�ۻ����=��"�v6�8�9g��r����b ��P�0�)��v���K4�[�3ۧwKkUׇ��9^(i���}��i9�;����R�[��^��>G�PZ��%ʐ��������qJ���K�������� ���5��͝dv�
9���D����Q�'�����(6����u���:�=a�èj
��k��$l����=�"1��C�MIiK[TwDck6�^�͵F߲���m{���L�ص4�aH���dNS�28�PеDr��8�I�� ��B�}?���]��?v�Y�|�9���f-x6���nڷW�`�5��\��^J�r��{���,�C��z}��{���46a�Dw�h�"�������i�_��r���*����?�,��Z�S>C����ʐ�������/��5�_��W��o�����b�+P}�s)�\��{w�q����RP��������[��P�������J���Ox�M���(�8�.C�F��O�L�8��C�O��#��b��`x��o�2�������_H���)��J˔l99�[�Ԍa��"4����V�X�<�-j���c�鸭��+�{ɚ�zb��vp�*�(�9����Q���w-���3�(C�Sez��RGYl�C�j��{����O���8�������s�/Ԟ|����������f���Z���2?�N]?�
�j����4�C�km�O�t�{a�����S�ʵ���"��k�����>}�_n�i�����|�Z��&N���4�����.�ë^�᧧&q�ξ_�_4B_���u:W��^z_k٤v���zz��Q���Uq��8[L~��;?���D��Bs�u>`�ڕS;-��z���ծ�Sl��&���5|ɮn_�����\�ӥ��,���}sw1��p�+܎����J_V��.[]]uQ�i�����MG��
A��o���ߋ��Ǿ�WD���e�ZUI��`�;j���y�av}�(�΢��/7�˃����·��śWk���Q��9l/^���o���:b��"{�a�5o�� ��w[/�������Z��_�N�~z5��5x���ߟ_ʾ��?��c��_m�\T{X����q:�.�o�~��q���8��8K]8��'�0Y?P�GR��jO>���D����8���}7@U�ȿ?���Y����?6��Wlñ�E��������w�F���Y��{�@�Uő�m�n�ǧM���וU��f9�}�axgkxk�p�Y�gO�:{��O��b�������{W�:Y��r���C	r9�e�p1�x��CE�n�v�n��7%מ�k�ukO�wb��L|	�7	!~ b������E��"h0ĈBL�h�m=��v���pA�s�{��������{����<O2�1F69_�)7�2�B�Y"� c���.������d&K]J�#�0�[۲vL@u�$uD���e8���V��i90���Xti1 ��f��O�9���mB�%�b¸�;�"�ʒ$�tpph|�m�5\����pr��5�!��L�nV)��8Z|ۀ��"&Y2b��h�n�ڨ�;VIp�><άW��w(IP�}F���H�t[��i��-���K��v��;ĻY�3n��2�`�g.��2{hJ#��U)�j�A�a�e����;��Cn��/��
��vI�Э����1�"���`��"yߢ�2@��S�(p�4��6�N}sp��/��������Ofw��h1�N�.�������U�*�z�̅��3���<'�Z����:��ӿ�e�M$�TҀő*�����#�é�e�猞N���"�9�eDi�ssW�kF���we>�W��k�ZS�*��n�9H3���E��ں��.2Y��<+e���)]����{�*wQ�h.P��Q�$
l����7��\sB�VWn�3Bs2��#���\���3�:�d4[PN�+�b��9���s�5D7r�I��6�sR�u�B��x���X��u��e���ۜ�i���i����Z;��O����\-VF�����l���ZT��ۅ�]��v�}�`�ՙ;pr*_ѫ��~8�4��F��QD��
���?�|@������V��q���?��Ps�?��ϻ��+q�(���8��������k-����6Ru�]W5��)�Xdۋ��~?�ƶ�,�X�g�W���Q�U�G8�rzF9�I�{����~�3����[���x�7�/?��K���s�+x���n<AA?s�kƁp�N��;؍�C/޹�s�*��sз�AO�����������}z��}O��)���7�׳�y`D��{Q�K�Y�G�c=:��%�I��9a�\/L�A��-��mf�7
�t��D�T��F�Hn��m�K��bg�Y��D?C�ݜ�����C�+��f�v�r/��|i����;]P�d�8̣X���'�9��-F�%��G��~��݂�0I��F���a�]��=L��~����юp�S��,>^$����YB�tv�W2��TQp�	�T����|��R^�+`XNU[BLHz.%5XHh[%U�)�͇���K�)Nz��R��C�\ڏ�=}�f��LX�	�
z�@��K티�M=u��6��D�����!\�kO͕�u��`�ck�tM�F�xP�*�'����&�e���G�~ee�h.O�B��j�Z�;J��0�m����D�!��$3�0i$]N�L�D�ɰX��'�9d�#<#;V0��x'�	���*�!VI�����.֊�x���|�&��4/^�@�0J��t}�3�r�t3��ۉx��R4���z��ǘȾ�h���>&eY�댲l�3����r)���TJÁߝhpp��$_�h��p�h8��mi�+�|+�Zb�
��b+-_�ʕ�A4���)�Ht^+JT�RU@�4�c�x�%��e����Re��<�+�ѴoHZ��ѭ+r���N$*g=�x�q�T���Z�yw�
�n!A�JFj~$�d��^��t�b	��U�[e�-R��e��,��%��z<C!�V�ˣ$���@HP� ACwR��fn��ya����^jX@�J�(o��ډa�\e�nu����@@N��,a1Y�b��E�@YIo�I�ҙ2� sʲGxFv��0�M�;�a|o�Uk}Z(�L�Y�W��K9o6�s�>t��7���#�}��rmB��<��g(F�I�-G�A��I;f?eq�>����>�j>��)��iN\SPkm^ՠ�@�֮�6�5�����g��_��L0>�.@]���<�Й�<�WNW���ʡ�ڸ\dۜh���N��\�����%r78C���9(%K5n ��n�9�Wڸ$�Nn�	n"F1�4��՚�UC�֦������-��e
�C��IM�dK�	�5[��y�f��X��琳?�n�iu�Y���U��^?a�\ 7
`��j���-������*��6Kf|bZf���=w��E�Q�Ϝ�^����釞�6]�ŉ�j|<� 't p�I_�?9Fֿ�:�G���ס�֡���g��/+�<~��=Zx0i-<H�HB�g*]�$�V������-<(��:"m����`8;4�E�A�΃�"Xu��Ҟ'�8ꂃ�V�Әn֔A�{b��0c	>nzh��;CjSj�W����R��2�p���%�!ъ#��P� 9��
�"Bpd�)�Ѽ��&�tR�J�zq�и�T���*u<F�	�=�#A!m��11���!�GM���c���ajt����D�;X�Uo%���r$ӈu����|~g�P�T�~e�m)�(�l؃�`����o�ol�m�v|��ń`KT�H
Q��k�f��I��[g���K5��K�xx_�p��a�m���]/�n�6ݩ�eʹ<m�Cc�d:��gZ1byv�@w肷Ne�:me��y'��@˽����ct�����a�/��eG�>8��U��Tp�m�$Rn�*�d�u���92P�x�#���*��r���A|&(2����E&����t��,�?=�.�f�!��T��Rv�b�J�`$�����8��
 LxG�p0%�e�	 ^V�$�i����e�;}_N�RBńp�0�����B�Bw;�l��aB�Ɩ�|;����JQ�u%
�6��J]��3�W,�mwD�Q�~�+�*x�����0₳L��٨f�A��lɅ���;<���-	�s.�n�$���\���&qW�^"�}�v^�ò��6��7�8��㞍��䔹���X!��RHn�0��Ep���m6�jb�%d�j�kwT3Z��=�0%�>�h╊�k��v�~��k����BqI��[���S�(����; �R��=G5��?���	�
�ͽ,f׫���ͭ�w|�_��KO=������_��е�~ ��U���5��N�i�D�c��@�'�ݻ���c�?/K�ǳ���'�ݗ�8��_������M}�ɯ�@���I�{q�T|'��ֵ+�_���=���t�Zڀξ������3_l�N��3NϿ^�ͯ�COB�S�5
�#�i����zs����M����6�Ӧ	�4��i�}�ŵ�v@ڦv��N��i�l���~�v�oy��A�\��g	#�0�M�M^�n[D�d<b��[��:�c��{ȟ�8�6EMx�y�[g��O���T�g`�m����#�.��r�^��f��Ӳ����V{Ό=-��`ϙ���6��0g��}�0�r�̹p�a�C��V�m����c$s���5p�蟝�d';��}���ъ  